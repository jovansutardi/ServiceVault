//
//  MaintenanceRecord.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct MaintenanceRecord: Identifiable, Equatable {
    let id: UUID
    let vehicleID: UUID

    var serviceType: String
    var serviceDate: Date
    var odometer: Int
    var workshopName: String
    var cost: Decimal?
    var notes: String

    var nextServiceDate: Date?
    var nextServiceOdometer: Int?
}
