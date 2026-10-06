//
//  RecordVehicleMaintenanceUseCase.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct RecordVehicleMaintenanceUseCase {

    let repository: MaintenanceRepository

    func execute(
        vehicleID: UUID,
        serviceType: String,
        serviceDate: Date,
        odometer: Int,
        workshopName: String,
        cost: Decimal?,
        notes: String,
        nextServiceDate: Date?,
        nextServiceOdometer: Int?
    ) throws -> MaintenanceRecord {

        let trimmedServiceType =
            serviceType.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedServiceType.isEmpty else {
            throw RecordMaintenanceError.missingServiceType
        }

        guard serviceDate <= Date() else {
            throw RecordMaintenanceError.futureServiceDate
        }

        guard odometer >= 0 else {
            throw RecordMaintenanceError.invalidOdometer
        }

        if let previousRecord = try repository.latestRecord(for: vehicleID),
           odometer < previousRecord.odometer {
            throw RecordMaintenanceError.odometerEarlierThanPreviousRecord
        }

        let record = MaintenanceRecord(
            id: UUID(),
            vehicleID: vehicleID,
            serviceType: trimmedServiceType,
            serviceDate: serviceDate,
            odometer: odometer,
            workshopName: workshopName,
            cost: cost,
            notes: notes,
            nextServiceDate: nextServiceDate,
            nextServiceOdometer: nextServiceOdometer
        )

        try repository.save(record)

        return record
    }
}
