//
//  ImportedDocumentsView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import SwiftUI

struct ImportedDocumentsView: View {

    @StateObject private var viewModel: DocumentsViewModel

    init(
        vehicleRepository: VehicleRepository,
        maintenanceRepository: MaintenanceRepository,
        attachServiceEvidenceUseCase: AttachServiceEvidenceUseCase
    ) {
        _viewModel = StateObject(
            wrappedValue: DocumentsViewModel(
                store: AppGroupImportedDocumentStore.shared,
                vehicleRepository: vehicleRepository,
                maintenanceRepository: maintenanceRepository,
                attachServiceEvidenceUseCase: attachServiceEvidenceUseCase
            )
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.documents.isEmpty {
                    ContentUnavailableView(
                        "No Imported Documents",
                        systemImage: "doc.badge.plus",
                        description: Text(
                            "Share a service invoice or document from Files, Mail, or another app to ServiceVault."
                        )
                    )
                } else {
                    List {
                        ForEach(viewModel.documents) { document in
                            NavigationLink {
                                ImportedDocumentDetailView(
                                    document: document,
                                    viewModel: viewModel
                                )
                            } label: {
                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    Text(document.fileName)
                                        .font(.headline)

                                    Text(
                                        document.importedDate.formatted(
                                            date: .abbreviated,
                                            time: .shortened
                                        )
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Documents")
            .task {
                viewModel.loadDocuments()
            }
        }
    }
}
