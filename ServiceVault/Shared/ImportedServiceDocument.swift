//
//  ImportedServiceDocument.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import Foundation

struct ImportedServiceDocument: Identifiable, Codable, Equatable {
    let id: UUID
    let fileName: String
    let storedFileName: String
    let importedDate: Date
}
