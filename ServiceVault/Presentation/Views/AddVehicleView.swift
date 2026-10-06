//
//  AddVehicleView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct AddVehicleView: View {

    @ObservedObject var viewModel: GarageViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var registration = ""
    @State private var odometer = ""

    var body: some View {
        NavigationStack {

            Form {

                Section("Vehicle") {

                    TextField(
                        "Make",
                        text: $make
                    )

                    TextField(
                        "Model",
                        text: $model
                    )

                    TextField(
                        "Year",
                        text: $year
                    )
                    .keyboardType(.numberPad)

                    TextField(
                        "Registration",
                        text: $registration
                    )

                    TextField(
                        "Current Odometer",
                        text: $odometer
                    )
                    .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Vehicle")
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
                    Button("Add") {

                        guard
                            let yearValue = Int(year),
                            let odometerValue = Int(odometer)
                        else {
                            viewModel.errorMessage =
                                "Enter a valid year and odometer reading."
                            return
                        }

                        viewModel.addVehicle(
                            make: make,
                            model: model,
                            year: yearValue,
                            registration: registration,
                            currentOdometer: odometerValue
                        )

                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
