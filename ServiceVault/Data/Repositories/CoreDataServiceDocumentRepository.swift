//
//  CoreDataServiceDocumentRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import CoreData
import Foundation

final class CoreDataServiceDocumentRepository: ServiceDocumentRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ document: ServiceDocument) throws {

        let request = CDServiceDocument.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            document.id as CVarArg
        )

        request.fetchLimit = 1

        let storedDocument =
            try context.fetch(request).first ?? CDServiceDocument(context: context)

        storedDocument.id = document.id
        storedDocument.title = document.title
        storedDocument.fileName = document.fileName
        storedDocument.importedDate = document.importedDate

        if let maintenanceRecordID = document.maintenanceRecordID {

            let recordRequest = CDMaintenanceRecord.fetchRequest()

            recordRequest.predicate = NSPredicate(
                format: "id == %@",
                maintenanceRecordID as CVarArg
            )

            recordRequest.fetchLimit = 1

            storedDocument.maintenanceRecord =
                try context.fetch(recordRequest).first
        }

        try context.save()
    }

    func documents(
        for maintenanceRecordID: UUID
    ) throws -> [ServiceDocument] {

        let request = CDServiceDocument.fetchRequest()

        request.predicate = NSPredicate(
            format: "maintenanceRecord.id == %@",
            maintenanceRecordID as CVarArg
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "importedDate",
                ascending: false
            )
        ]

        let storedDocuments = try context.fetch(request)

        return storedDocuments.compactMap {
            mapToDomain($0)
        }
    }

    func documentExists(
        fileName: String,
        for maintenanceRecordID: UUID
    ) throws -> Bool {

        let request = CDServiceDocument.fetchRequest()

        request.predicate = NSPredicate(
            format: """
            fileName == %@ AND
            maintenanceRecord.id == %@
            """,
            fileName,
            maintenanceRecordID as CVarArg
        )

        request.fetchLimit = 1

        return try context.count(for: request) > 0
    }

    private func mapToDomain(
        _ storedDocument: CDServiceDocument
    ) -> ServiceDocument? {

        guard
            let id = storedDocument.id,
            let title = storedDocument.title,
            let fileName = storedDocument.fileName,
            let importedDate = storedDocument.importedDate
        else {
            return nil
        }

        return ServiceDocument(
            id: id,
            maintenanceRecordID:
                storedDocument.maintenanceRecord?.id,
            title: title,
            fileName: fileName,
            importedDate: importedDate
        )
    }
}
