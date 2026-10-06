//
//  GarageViewModel.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
import Combine

@MainActor
final class GarageViewModel: ObservableObject {

    @Published var vehicles: [Vehicle] = []
    @Published var errorMessage: String?

    private let vehicleRepository: VehicleRepository
    private let widgetSyncService: WidgetSyncService

    init(
        vehicleRepository: VehicleRepository,
        widgetSyncService: WidgetSyncService
    ) {
        self.vehicleRepository = vehicleRepository
        self.widgetSyncService = widgetSyncService
    }

    func loadVehicles() {
        do {
            vehicles = try vehicleRepository.fetchVehicles()
            errorMessage = nil
        } catch {
            errorMessage = "Your vehicles could not be loaded. Please try again."
        }
    }

    func addVehicle(
        make: String,
        model: String,
        year: Int,
        registration: String,
        currentOdometer: Int
    ) {

        let trimmedMake =
            make.trimmingCharacters(in: .whitespacesAndNewlines)

        let trimmedModel =
            model.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedMake.isEmpty, !trimmedModel.isEmpty else {
            errorMessage = "Enter the vehicle make and model."
            return
        }

        guard year > 1900 else {
            errorMessage = "Enter a valid vehicle year."
            return
        }

        guard currentOdometer >= 0 else {
            errorMessage = "Enter a valid odometer reading."
            return
        }

        let vehicle = Vehicle(
            id: UUID(),
            make: trimmedMake,
            model: trimmedModel,
            year: year,
            registration: registration,
            currentOdometer: currentOdometer
        )

        do {
            try vehicleRepository.save(vehicle)

            loadVehicles()

            widgetSyncService.refreshWidget()

        } catch {
            errorMessage = "The vehicle could not be saved. Please try again."
        }
    }
}
