//
//  MaintenanceRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

protocol MaintenanceRepository {
    func save(_ record: MaintenanceRecord) throws

    func records(
        for vehicleID: UUID
    ) throws -> [MaintenanceRecord]

    func latestRecord(
        for vehicleID: UUID
    ) throws -> MaintenanceRecord?

    func upcomingMaintenance(
        for vehicleID: UUID,
        currentOdometer: Int,
        withinDays days: Int,
        withinKilometres kilometres: Int
    ) throws -> [MaintenanceRecord]
}
