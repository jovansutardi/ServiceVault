//
//  MaintenanceDetailView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct MaintenanceDetailView: View {

    let record: MaintenanceRecord

    @StateObject private var viewModel: MaintenanceDetailViewModel

    init(
        record: MaintenanceRecord,
        serviceDocumentRepository: ServiceDocumentRepository
    ) {
        self.record = record

        _viewModel = StateObject(
            wrappedValue: MaintenanceDetailViewModel(
                record: record,
                serviceDocumentRepository: serviceDocumentRepository
            )
        )
    }

    var body: some View {

        List {

            Section("Maintenance") {

                LabeledContent(
                    "Service",
                    value: record.serviceType
                )

                LabeledContent(
                    "Date",
                    value: record.serviceDate.formatted(
                        date: .long,
                        time: .omitted
                    )
                )

                LabeledContent(
                    "Odometer",
                    value: "\(record.odometer.formatted()) km"
                )
            }

            if !record.workshopName.isEmpty {
                Section("Workshop") {
                    Text(record.workshopName)
                }
            }

            if let cost = record.cost {
                Section("Cost") {
                    Text(
                        cost.formatted(
                            .currency(code: "AUD")
                        )
                    )
                }
            }

            if !record.notes.isEmpty {
                Section("Notes") {
                    Text(record.notes)
                }
            }

            if record.nextServiceDate != nil ||
                record.nextServiceOdometer != nil {

                Section("Next Service") {

                    if let nextDate = record.nextServiceDate {
                        LabeledContent(
                            "Due Date",
                            value: nextDate.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )
                    }

                    if let nextOdometer = record.nextServiceOdometer {
                        LabeledContent(
                            "Due Odometer",
                            value: "\(nextOdometer.formatted()) km"
                        )
                    }
                }
            }

            Section("Service Evidence") {

                if viewModel.documents.isEmpty {

                    Text("No service documents attached.")
                        .foregroundStyle(.secondary)

                } else {

                    ForEach(viewModel.documents) { document in

                        if let url = viewModel.fileURL(
                            for: document
                        ) {

                            ShareLink(
                                item: url
                            ) {

                                HStack {

                                    Image(
                                        systemName: "doc.fill"
                                    )

                                    VStack(
                                        alignment: .leading,
                                        spacing: 4
                                    ) {

                                        Text(document.title)
                                            .foregroundStyle(.primary)

                                        Text(
                                            document.importedDate.formatted(
                                                date: .abbreviated,
                                                time: .shortened
                                            )
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            }

                        } else {

                            Label(
                                document.title,
                                systemImage:
                                    "exclamationmark.triangle"
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle(record.serviceType)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadDocuments()
        }
        .alert(
            "ServiceVault",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { value in
                    if !value {
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
