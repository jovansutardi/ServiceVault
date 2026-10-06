//
//  ServiceDocument.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct ServiceDocument: Identifiable, Equatable {
    let id: UUID
    let maintenanceRecordID: UUID?

    var title: String
    var fileName: String
    var importedDate: Date
}
