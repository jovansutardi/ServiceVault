//
//  MockServiceDocumentRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
@testable import ServiceVault

final class MockServiceDocumentRepository: ServiceDocumentRepository {

    var storedDocuments: [ServiceDocument] = []

    func save(_ document: ServiceDocument) throws {
        storedDocuments.append(document)
    }

    func documents(
        for maintenanceRecordID: UUID
    ) throws -> [ServiceDocument] {

        storedDocuments.filter {
            $0.maintenanceRecordID == maintenanceRecordID
        }
    }

    func documentExists(
        fileName: String,
        for maintenanceRecordID: UUID
    ) throws -> Bool {

        storedDocuments.contains {
            $0.fileName == fileName &&
            $0.maintenanceRecordID == maintenanceRecordID
        }
    }
}
