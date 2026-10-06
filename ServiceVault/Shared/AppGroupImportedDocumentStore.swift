//
//  AppGroupImportedDocumentStore.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import Foundation

final class AppGroupImportedDocumentStore {

    static let shared = AppGroupImportedDocumentStore()

    static let appGroupID =
        "group.com.jovansutardi.ServiceVault"

    private let metadataKey =
        "pendingServiceDocuments"

    private init() {}

    func saveImportedFile(
        temporaryURL: URL
    ) throws -> ImportedServiceDocument {

        guard let containerURL =
                FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier:
                        Self.appGroupID
                )
        else {
            throw ImportStoreError.appGroupUnavailable
        }

        let importsFolder =
            containerURL.appendingPathComponent(
                "Imports",
                isDirectory: true
            )

        try FileManager.default.createDirectory(
            at: importsFolder,
            withIntermediateDirectories: true
        )

        let originalName =
            temporaryURL.lastPathComponent

        let storedName =
            "\(UUID().uuidString)-\(originalName)"

        let destination =
            importsFolder.appendingPathComponent(
                storedName
            )

        try FileManager.default.copyItem(
            at: temporaryURL,
            to: destination
        )

        let document =
            ImportedServiceDocument(
                id: UUID(),
                fileName: originalName,
                storedFileName: storedName,
                importedDate: Date()
            )

        var documents =
            fetchPendingDocuments()

        documents.append(document)

        try saveMetadata(documents)

        return document
    }

    func fetchPendingDocuments()
        -> [ImportedServiceDocument] {

        guard
            let defaults = UserDefaults(
                suiteName: Self.appGroupID
            ),
            let data = defaults.data(
                forKey: metadataKey
            ),
            let documents =
                try? JSONDecoder().decode(
                    [ImportedServiceDocument].self,
                    from: data
                )
        else {
            return []
        }

        return documents.sorted {
            $0.importedDate > $1.importedDate
        }
    }

    func fileURL(
        for document: ImportedServiceDocument
    ) -> URL? {

        guard let containerURL =
                FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier:
                        Self.appGroupID
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
                document.storedFileName
            )
    }

    func remove(
        _ document: ImportedServiceDocument
    ) throws {

        if let url = fileURL(for: document),
           FileManager.default.fileExists(
                atPath: url.path
           ) {
            try FileManager.default.removeItem(
                at: url
            )
        }

        var documents =
            fetchPendingDocuments()

        documents.removeAll {
            $0.id == document.id
        }

        try saveMetadata(documents)
    }
    
    func markProcessed(
        _ document: ImportedServiceDocument
    ) throws {

        var documents = fetchPendingDocuments()

        documents.removeAll {
            $0.id == document.id
        }

        try saveMetadata(documents)
    }

    private func saveMetadata(
        _ documents: [ImportedServiceDocument]
    ) throws {

        guard let defaults = UserDefaults(
            suiteName: Self.appGroupID
        ) else {
            throw ImportStoreError.appGroupUnavailable
        }

        let data =
            try JSONEncoder().encode(documents)

        defaults.set(
            data,
            forKey: metadataKey
        )
    }
}

enum ImportStoreError: LocalizedError {
    case appGroupUnavailable

    var errorDescription: String? {
        "ServiceVault could not access its shared document storage."
    }
}
