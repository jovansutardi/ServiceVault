//
//  WidgetSyncService.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
import WidgetKit

struct WidgetSyncService {

    let vehicleRepository: VehicleRepository
    let maintenanceRepository: MaintenanceRepository

    func refreshWidget() {
        do {
            guard let vehicle = try vehicleRepository.fetchVehicles().first else {
                return
            }

            let upcoming = try maintenanceRepository.upcomingMaintenance(
                for: vehicle.id,
                currentOdometer: vehicle.currentOdometer,
                withinDays: 30,
                withinKilometres: 1000
            )

            let nextRecord = upcoming.first

            let snapshot = WidgetSnapshot(
                vehicleName: vehicle.displayName,
                nextServiceDate: nextRecord?.nextServiceDate,
                nextServiceOdometer: nextRecord?.nextServiceOdometer,
                currentOdometer: vehicle.currentOdometer,
                urgentMaintenanceCount: upcoming.count
            )

            WidgetSnapshotStore.save(snapshot)

            WidgetCenter.shared.reloadAllTimelines()

        } catch {
            print("Widget refresh failed: \(error)")
        }
    }
}
