//
//  ReviewUpcomingMaintenanceUseCase.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct ReviewUpcomingMaintenanceUseCase {

    let vehicleRepository: VehicleRepository
    let maintenanceRepository: MaintenanceRepository

    func execute(
        vehicleID: UUID,
        withinDays days: Int = 30,
        withinKilometres kilometres: Int = 1000
    ) throws -> [MaintenanceRecord] {

        guard days > 0, kilometres > 0 else {
            throw UpcomingMaintenanceError.invalidReviewPeriod
        }

        guard let vehicle = try vehicleRepository.findVehicle(id: vehicleID) else {
            throw UpcomingMaintenanceError.vehicleNotFound
        }

        return try maintenanceRepository.upcomingMaintenance(
            for: vehicleID,
            currentOdometer: vehicle.currentOdometer,
            withinDays: days,
            withinKilometres: kilometres
        )
    }
}
