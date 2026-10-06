//
//  UpcomingMaintenanceViewModel.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
import Combine

@MainActor
final class UpcomingMaintenanceViewModel: ObservableObject {

    @Published var items: [MaintenanceRecord] = []
    @Published var errorMessage: String?

    private let vehicleRepository: VehicleRepository
    private let reviewUpcomingMaintenanceUseCase: ReviewUpcomingMaintenanceUseCase

    init(
        vehicleRepository: VehicleRepository,
        reviewUpcomingMaintenanceUseCase: ReviewUpcomingMaintenanceUseCase
    ) {
        self.vehicleRepository = vehicleRepository
        self.reviewUpcomingMaintenanceUseCase = reviewUpcomingMaintenanceUseCase
    }

    func loadUpcomingMaintenance() {
        do {
            let vehicles = try vehicleRepository.fetchVehicles()

            var upcoming: [MaintenanceRecord] = []

            for vehicle in vehicles {
                let records = try reviewUpcomingMaintenanceUseCase.execute(
                    vehicleID: vehicle.id
                )

                upcoming.append(contentsOf: records)
            }

            items = upcoming.sorted {
                ($0.nextServiceDate ?? .distantFuture) <
                ($1.nextServiceDate ?? .distantFuture)
            }

            errorMessage = nil

        } catch {
            errorMessage =
                "Upcoming maintenance could not be loaded. Please try again."
        }
    }
}
