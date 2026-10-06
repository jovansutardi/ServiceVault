//
//  CoreDataMaintenanceRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import CoreData
import Foundation

final class CoreDataMaintenanceRepository: MaintenanceRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ record: MaintenanceRecord) throws {

        let request = CDMaintenanceRecord.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            record.id as CVarArg
        )
        request.fetchLimit = 1

        let storedRecord =
            try context.fetch(request).first ?? CDMaintenanceRecord(context: context)

        storedRecord.id = record.id
        storedRecord.serviceType = record.serviceType
        storedRecord.serviceDate = record.serviceDate
        storedRecord.odometer = Int64(record.odometer)
        storedRecord.workshopName = record.workshopName
        storedRecord.cost = record.cost as NSDecimalNumber?
        storedRecord.notes = record.notes
        storedRecord.nextServiceDate = record.nextServiceDate

        if let nextOdometer = record.nextServiceOdometer {
            storedRecord.nextServiceOdometer = Int64(nextOdometer)
        }

        let vehicleRequest = CDVehicle.fetchRequest()
        vehicleRequest.predicate = NSPredicate(
            format: "id == %@",
            record.vehicleID as CVarArg
        )
        vehicleRequest.fetchLimit = 1

        guard let storedVehicle = try context.fetch(vehicleRequest).first else {
            throw UpcomingMaintenanceError.vehicleNotFound
        }

        storedRecord.vehicle = storedVehicle

        try context.save()
    }

    func records(
        for vehicleID: UUID
    ) throws -> [MaintenanceRecord] {

        let request = CDMaintenanceRecord.fetchRequest()

        request.predicate = NSPredicate(
            format: "vehicle.id == %@",
            vehicleID as CVarArg
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "serviceDate",
                ascending: false
            )
        ]

        let storedRecords = try context.fetch(request)

        return storedRecords.compactMap {
            mapToDomain($0)
        }
    }

    func latestRecord(
        for vehicleID: UUID
    ) throws -> MaintenanceRecord? {

        let request = CDMaintenanceRecord.fetchRequest()

        request.predicate = NSPredicate(
            format: "vehicle.id == %@",
            vehicleID as CVarArg
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "serviceDate",
                ascending: false
            )
        ]

        request.fetchLimit = 1

        guard let storedRecord = try context.fetch(request).first else {
            return nil
        }

        return mapToDomain(storedRecord)
    }

    func upcomingMaintenance(
        for vehicleID: UUID,
        currentOdometer: Int,
        withinDays days: Int,
        withinKilometres kilometres: Int
    ) throws -> [MaintenanceRecord] {

        guard let cutoffDate = Calendar.current.date(
            byAdding: .day,
            value: days,
            to: Date()
        ) else {
            return []
        }

        let odometerLimit = currentOdometer + kilometres

        let request = CDMaintenanceRecord.fetchRequest()

        request.predicate = NSPredicate(
            format: """
            vehicle.id == %@ AND
            (
                nextServiceDate <= %@ OR
                nextServiceOdometer <= %lld
            )
            """,
            vehicleID as CVarArg,
            cutoffDate as NSDate,
            Int64(odometerLimit)
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "nextServiceDate",
                ascending: true
            )
        ]

        let storedRecords = try context.fetch(request)

        return storedRecords.compactMap {
            mapToDomain($0)
        }
    }

    private func mapToDomain(
        _ storedRecord: CDMaintenanceRecord
    ) -> MaintenanceRecord? {

        guard
            let id = storedRecord.id,
            let serviceType = storedRecord.serviceType,
            let serviceDate = storedRecord.serviceDate,
            let workshopName = storedRecord.workshopName,
            let notes = storedRecord.notes,
            let vehicleID = storedRecord.vehicle?.id
        else {
            return nil
        }

        return MaintenanceRecord(
            id: id,
            vehicleID: vehicleID,
            serviceType: serviceType,
            serviceDate: serviceDate,
            odometer: Int(storedRecord.odometer),
            workshopName: workshopName,
            cost: storedRecord.cost as Decimal?,
            notes: notes,
            nextServiceDate: storedRecord.nextServiceDate,
            nextServiceOdometer:
                storedRecord.nextServiceOdometer == 0
                ? nil
                : Int(storedRecord.nextServiceOdometer)
        )
    }
}
