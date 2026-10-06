//
//  ImportedDocumentDetailView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import SwiftUI

struct ImportedDocumentDetailView: View {

    let document: ImportedServiceDocument

    @ObservedObject var viewModel: DocumentsViewModel

    @State private var showingAttachSheet = false

    private let store =
        AppGroupImportedDocumentStore.shared

    var body: some View {

        List {

            Section("Imported Document") {

                LabeledContent(
                    "File",
                    value: document.fileName
                )

                LabeledContent(
                    "Imported",
                    value:
                        document.importedDate.formatted(
                            date: .long,
                            time: .shortened
                        )
                )
            }

            Section("Actions") {

                Button {
                    viewModel.loadMaintenanceRecords()
                    showingAttachSheet = true

                } label: {

                    Label(
                        "Attach to Maintenance Record",
                        systemImage: "paperclip"
                    )
                }

                if let url =
                    store.fileURL(for: document) {

                    ShareLink(
                        item: url
                    ) {
                        Label(
                            "Open / Share Document",
                            systemImage: "square.and.arrow.up"
                        )
                    }
                }
            }

            Section {

                Text(
                    "Attach this invoice or service document to the maintenance work it provides evidence for."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Service Document")
        .navigationBarTitleDisplayMode(.inline)

        .sheet(
            isPresented: $showingAttachSheet
        ) {
            AttachImportedDocumentView(
                document: document,
                viewModel: viewModel
            )
        }
    }
}
