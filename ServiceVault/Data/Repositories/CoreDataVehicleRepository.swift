//
//  CoreDataVehicleRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import CoreData
import Foundation

final class CoreDataVehicleRepository: VehicleRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(_ vehicle: Vehicle) throws {

        let request = CDVehicle.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            vehicle.id as CVarArg
        )
        request.fetchLimit = 1

        let storedVehicle =
            try context.fetch(request).first ?? CDVehicle(context: context)

        storedVehicle.id = vehicle.id
        storedVehicle.make = vehicle.make
        storedVehicle.model = vehicle.model
        storedVehicle.year = Int32(vehicle.year)
        storedVehicle.registration = vehicle.registration
        storedVehicle.currentOdometer = Int64(vehicle.currentOdometer)

        try context.save()
    }

    func fetchVehicles() throws -> [Vehicle] {

        let request = CDVehicle.fetchRequest()

        let storedVehicles = try context.fetch(request)

        return storedVehicles.compactMap { storedVehicle in
            guard
                let id = storedVehicle.id,
                let make = storedVehicle.make,
                let model = storedVehicle.model,
                let registration = storedVehicle.registration
            else {
                return nil
            }

            return Vehicle(
                id: id,
                make: make,
                model: model,
                year: Int(storedVehicle.year),
                registration: registration,
                currentOdometer: Int(storedVehicle.currentOdometer)
            )
        }
    }

    func findVehicle(id: UUID) throws -> Vehicle? {

        let request = CDVehicle.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        request.fetchLimit = 1

        guard let storedVehicle = try context.fetch(request).first else {
            return nil
        }

        guard
            let storedID = storedVehicle.id,
            let make = storedVehicle.make,
            let model = storedVehicle.model,
            let registration = storedVehicle.registration
        else {
            return nil
        }

        return Vehicle(
            id: storedID,
            make: make,
            model: model,
            year: Int(storedVehicle.year),
            registration: registration,
            currentOdometer: Int(storedVehicle.currentOdometer)
        )
    }
}
