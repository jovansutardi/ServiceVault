//
//  GarageView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct GarageView: View {

    @StateObject private var viewModel: GarageViewModel

    @State private var showingAddVehicle = false

    init(
        vehicleRepository: VehicleRepository,
        widgetSyncService: WidgetSyncService
    ) {
        _viewModel = StateObject(
            wrappedValue: GarageViewModel(
                vehicleRepository: vehicleRepository,
                widgetSyncService: widgetSyncService
            )
        )
    }

    var body: some View {
        NavigationStack {
            Group {

                if viewModel.vehicles.isEmpty {
                    emptyState
                } else {
                    vehicleList
                }
            }
            .navigationTitle("My Vehicles")
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button {
                        showingAddVehicle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddVehicle) {
                AddVehicleView(
                    viewModel: viewModel
                )
            }
            .task {
                viewModel.loadVehicles()
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

    private var vehicleList: some View {
        List(viewModel.vehicles) { vehicle in

            NavigationLink {
                VehicleDetailView(
                    vehicle: vehicle
                )
            } label: {

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text(vehicle.displayName)
                        .font(.headline)

                    if !vehicle.registration.isEmpty {
                        Text(vehicle.registration)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(
                        "\(vehicle.currentOdometer.formatted()) km"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
    private var emptyState: some View {
        ContentUnavailableView(
            "No Vehicles Yet",
            systemImage: "car.fill",
            description: Text(
                "Add your first vehicle to begin building its service history."
            )
        )
    }
}
