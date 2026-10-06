//
//  UpcomingMaintenanceView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct UpcomingMaintenanceView: View {

    @StateObject private var viewModel: UpcomingMaintenanceViewModel

    init(
        vehicleRepository: VehicleRepository,
        reviewUpcomingMaintenanceUseCase: ReviewUpcomingMaintenanceUseCase
    ) {
        _viewModel = StateObject(
            wrappedValue: UpcomingMaintenanceViewModel(
                vehicleRepository: vehicleRepository,
                reviewUpcomingMaintenanceUseCase:
                    reviewUpcomingMaintenanceUseCase
            )
        )
    }

    var body: some View {
        NavigationStack {

            Group {

                if viewModel.items.isEmpty {

                    ContentUnavailableView(
                        "No Maintenance Due",
                        systemImage: "checkmark.circle",
                        description: Text(
                            "Your vehicles have no maintenance due within the current review period."
                        )
                    )

                } else {

                    List(viewModel.items) { record in

                        NavigationLink {
                            MaintenanceDetailView(
                                record: record,
                                serviceDocumentRepository:
                                    AppContainer.shared.serviceDocumentRepository
                            )
                        } label: {

                            VStack(
                                alignment: .leading,
                                spacing: 6
                            ) {

                                Text(record.serviceType)
                                    .font(.headline)

                                if let date = record.nextServiceDate {
                                    Text(
                                        "Due \(date.formatted(date: .abbreviated, time: .omitted))"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }

                                if let odometer = record.nextServiceOdometer {
                                    Text(
                                        "Due at \(odometer.formatted()) km"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Upcoming Maintenance")
            .task {
                viewModel.loadUpcomingMaintenance()
            }
            .refreshable {
                viewModel.loadUpcomingMaintenance()
            }
            .alert(
                "ServiceVault",
                isPresented: Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: { newValue in
                        if !newValue {
                            viewModel.errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
