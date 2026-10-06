//
//  RecordMaintenanceView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct RecordMaintenanceView: View {

    let vehicle: Vehicle

    @ObservedObject var viewModel: MaintenanceViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var serviceType = ""
    @State private var serviceDate = Date()
    @State private var odometer = ""
    @State private var workshopName = ""
    @State private var cost = ""
    @State private var notes = ""

    @State private var includeNextServiceDate = false
    @State private var nextServiceDate = Date()

    @State private var includeNextOdometer = false
    @State private var nextServiceOdometer = ""

    var body: some View {

        NavigationStack {

            Form {

                Section("Completed Maintenance") {

                    TextField(
                        "Service Type",
                        text: $serviceType
                    )

                    DatePicker(
                        "Service Date",
                        selection: $serviceDate,
                        displayedComponents: .date
                    )

                    TextField(
                        "Odometer",
                        text: $odometer
                    )
                    .keyboardType(.numberPad)

                    TextField(
                        "Workshop",
                        text: $workshopName
                    )

                    TextField(
                        "Cost",
                        text: $cost
                    )
                    .keyboardType(.decimalPad)
                }

                Section("Notes") {

                    TextField(
                        "Work performed",
                        text: $notes,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                Section("Next Service") {

                    Toggle(
                        "Set Next Service Date",
                        isOn: $includeNextServiceDate
                    )

                    if includeNextServiceDate {

                        DatePicker(
                            "Next Service",
                            selection: $nextServiceDate,
                            displayedComponents: .date
                        )
                    }

                    Toggle(
                        "Set Next Service Odometer",
                        isOn: $includeNextOdometer
                    )

                    if includeNextOdometer {

                        TextField(
                            "Next Service Odometer",
                            text: $nextServiceOdometer
                        )
                        .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle("Record Maintenance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .cancellationAction
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(
                    placement: .confirmationAction
                ) {

                    Button("Save") {
                        saveMaintenance()
                    }
                }
            }
        }
    }

    private func saveMaintenance() {

        guard let odometerValue = Int(odometer) else {

            viewModel.errorMessage =
                "Enter a valid odometer reading."

            return
        }

        let costValue: Decimal?

        if cost.isEmpty {
            costValue = nil
        } else {
            costValue = Decimal(
                string: cost
            )
        }

        let nextOdometerValue: Int?

        if includeNextOdometer {

            guard let parsedOdometer =
                Int(nextServiceOdometer)
            else {

                viewModel.errorMessage =
                    "Enter a valid next service odometer reading."

                return
            }

            nextOdometerValue =
                parsedOdometer

        } else {

            nextOdometerValue = nil
        }

        viewModel.recordMaintenance(
            serviceType: serviceType,
            serviceDate: serviceDate,
            odometer: odometerValue,
            workshopName: workshopName,
            cost: costValue,
            notes: notes,
            nextServiceDate:
                includeNextServiceDate
                ? nextServiceDate
                : nil,
            nextServiceOdometer:
                nextOdometerValue
        )

        if viewModel.errorMessage == nil {
            dismiss()
        }
    }
}
