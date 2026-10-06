//
//  AttachServiceEvidenceUseCase.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct AttachServiceEvidenceUseCase {

    let repository: ServiceDocumentRepository

    func execute(
        maintenanceRecordID: UUID,
        title: String,
        fileName: String,
        importedDate: Date = Date()
    ) throws -> ServiceDocument {

        let trimmedTitle =
            title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            throw ServiceEvidenceError.missingTitle
        }

        let allowedExtensions = ["pdf", "jpg", "jpeg", "png"]

        let fileExtension =
            URL(fileURLWithPath: fileName)
                .pathExtension
                .lowercased()

        guard allowedExtensions.contains(fileExtension) else {
            throw ServiceEvidenceError.unsupportedDocument
        }

        let alreadyExists = try repository.documentExists(
            fileName: fileName,
            for: maintenanceRecordID
        )

        guard !alreadyExists else {
            throw ServiceEvidenceError.duplicateDocument
        }

        let document = ServiceDocument(
            id: UUID(),
            maintenanceRecordID: maintenanceRecordID,
            title: trimmedTitle,
            fileName: fileName,
            importedDate: importedDate
        )

        try repository.save(document)

        return document
    }
}
