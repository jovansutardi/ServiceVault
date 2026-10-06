//
//  MockMaintenanceRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
@testable import ServiceVault

final class MockMaintenanceRepository: MaintenanceRepository {

    var storedRecords: [MaintenanceRecord] = []

    func save(_ record: MaintenanceRecord) throws {
        storedRecords.append(record)
    }

    func records(for vehicleID: UUID) throws -> [MaintenanceRecord] {
        storedRecords.filter { $0.vehicleID == vehicleID }
    }

    func latestRecord(for vehicleID: UUID) throws -> MaintenanceRecord? {
        storedRecords
            .filter { $0.vehicleID == vehicleID }
            .sorted { $0.serviceDate > $1.serviceDate }
            .first
    }

    func upcomingMaintenance(
        for vehicleID: UUID,
        currentOdometer: Int,
        withinDays days: Int,
        withinKilometres kilometres: Int
    ) throws -> [MaintenanceRecord] {

        let cutoffDate = Calendar.current.date(
            byAdding: .day,
            value: days,
            to: Date()
        )!

        return storedRecords.filter { record in
            guard record.vehicleID == vehicleID else {
                return false
            }

            let dueByDate: Bool = {
                guard let date = record.nextServiceDate else {
                    return false
                }

                return date <= cutoffDate
            }()

            let dueByOdometer: Bool = {
                guard let odometer = record.nextServiceOdometer else {
                    return false
                }

                return odometer <= currentOdometer + kilometres
            }()

            return dueByDate || dueByOdometer
        }
    }
}
