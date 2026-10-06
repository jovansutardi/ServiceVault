//
//  MaintenanceViewModel.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
import Combine

@MainActor
final class MaintenanceViewModel: ObservableObject {

    @Published var records: [MaintenanceRecord] = []
    @Published var errorMessage: String?

    private let vehicle: Vehicle
    private let maintenanceRepository: MaintenanceRepository
    private let recordMaintenanceUseCase: RecordVehicleMaintenanceUseCase
    private let widgetSyncService: WidgetSyncService

    init(
        vehicle: Vehicle,
        maintenanceRepository: MaintenanceRepository,
        recordMaintenanceUseCase: RecordVehicleMaintenanceUseCase,
        widgetSyncService: WidgetSyncService
    ) {
        self.vehicle = vehicle
        self.maintenanceRepository = maintenanceRepository
        self.recordMaintenanceUseCase = recordMaintenanceUseCase
        self.widgetSyncService = widgetSyncService
    }

    func loadRecords() {
        do {
            records = try maintenanceRepository.records(
                for: vehicle.id
            )

            errorMessage = nil
        } catch {
            errorMessage =
                "Your maintenance history could not be loaded. Please try again."
        }
    }

    func recordMaintenance(
        serviceType: String,
        serviceDate: Date,
        odometer: Int,
        workshopName: String,
        cost: Decimal?,
        notes: String,
        nextServiceDate: Date?,
        nextServiceOdometer: Int?
    ) {

        do {
            _ = try recordMaintenanceUseCase.execute(
                vehicleID: vehicle.id,
                serviceType: serviceType,
                serviceDate: serviceDate,
                odometer: odometer,
                workshopName: workshopName,
                cost: cost,
                notes: notes,
                nextServiceDate: nextServiceDate,
                nextServiceOdometer: nextServiceOdometer
            )

            loadRecords()
            widgetSyncService.refreshWidget()

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
