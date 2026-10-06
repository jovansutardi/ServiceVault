//
//  MaintenanceDetailViewModel.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import Foundation
import Combine

@MainActor
final class MaintenanceDetailViewModel: ObservableObject {

    @Published var documents: [ServiceDocument] = []
    @Published var errorMessage: String?

    private let record: MaintenanceRecord
    private let serviceDocumentRepository: ServiceDocumentRepository

    init(
        record: MaintenanceRecord,
        serviceDocumentRepository: ServiceDocumentRepository
    ) {
        self.record = record
        self.serviceDocumentRepository = serviceDocumentRepository
    }

    func loadDocuments() {
        do {
            documents = try serviceDocumentRepository.documents(
                for: record.id
            )

            errorMessage = nil

        } catch {
            errorMessage =
                "Service evidence could not be loaded. Please try again."
        }
    }

    func fileURL(
        for document: ServiceDocument
    ) -> URL? {

        guard let containerURL =
                FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier:
                        AppGroupImportedDocumentStore.appGroupID
                )
        else {
            return nil
        }

        return containerURL
            .appendingPathComponent(
                "Imports",
                isDirectory: true
            )
            .appendingPathComponent(
                document.fileName
            )
    }
}
