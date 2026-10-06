//
//  VehicleDetailView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct VehicleDetailView: View {

    let vehicle: Vehicle

    private let container = AppContainer.shared

    var body: some View {

        List {

            Section("Vehicle") {

                LabeledContent(
                    "Make",
                    value: vehicle.make
                )

                LabeledContent(
                    "Model",
                    value: vehicle.model
                )

                LabeledContent(
                    "Year",
                    value: String(vehicle.year)
                )

                if !vehicle.registration.isEmpty {
                    LabeledContent(
                        "Registration",
                        value: vehicle.registration
                    )
                }

                LabeledContent(
                    "Odometer",
                    value: "\(vehicle.currentOdometer.formatted()) km"
                )
            }

            Section("Maintenance") {

                NavigationLink {

                    MaintenanceHistoryView(
                        vehicle: vehicle,
                        maintenanceRepository:
                            container.maintenanceRepository,
                        recordMaintenanceUseCase:
                            container.recordVehicleMaintenanceUseCase,
                        widgetSyncService: container.widgetSyncService
                    )

                } label: {

                    Label(
                        "Service History",
                        systemImage: "wrench.and.screwdriver"
                    )
                }
            }
        }
        .navigationTitle(vehicle.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
