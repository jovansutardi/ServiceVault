//
//  ServiceDocumentRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

protocol ServiceDocumentRepository {
    func save(_ document: ServiceDocument) throws

    func documents(
        for maintenanceRecordID: UUID
    ) throws -> [ServiceDocument]

    func documentExists(
        fileName: String,
        for maintenanceRecordID: UUID
    ) throws -> Bool
}
