//
//  MaintenanceHistoryView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct MaintenanceHistoryView: View {

    let vehicle: Vehicle

    @StateObject private var viewModel: MaintenanceViewModel

    @State private var showingRecordMaintenance = false

    init(
        vehicle: Vehicle,
        maintenanceRepository: MaintenanceRepository,
        recordMaintenanceUseCase: RecordVehicleMaintenanceUseCase,
        widgetSyncService: WidgetSyncService
    ) {

        self.vehicle = vehicle

        _viewModel = StateObject(
            wrappedValue: MaintenanceViewModel(
                vehicle: vehicle,
                maintenanceRepository: maintenanceRepository,
                recordMaintenanceUseCase: recordMaintenanceUseCase,
                widgetSyncService: widgetSyncService
            )
        )
    }

    var body: some View {

        Group {

            if viewModel.records.isEmpty {

                ContentUnavailableView(
                    "No Service History",
                    systemImage: "wrench.and.screwdriver",
                    description: Text(
                        "Record the first maintenance item for this vehicle."
                    )
                )

            } else {

                List(viewModel.records) { record in

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

                            Text(
                                record.serviceDate.formatted(
                                    date: .abbreviated,
                                    time: .omitted
                                )
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                            Text(
                                "\(record.odometer.formatted()) km"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Service History")
        .toolbar {

            ToolbarItem(
                placement: .topBarTrailing
            ) {

                Button {
                    showingRecordMaintenance = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(
            isPresented: $showingRecordMaintenance
        ) {

            RecordMaintenanceView(
                vehicle: vehicle,
                viewModel: viewModel
            )
        }
        .task {
            viewModel.loadRecords()
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

            Text(
                viewModel.errorMessage ?? ""
            )
        }
    }
}
