//
//  AttachImportedDocumentView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import SwiftUI

struct AttachImportedDocumentView: View {
    
    let document: ImportedServiceDocument
    
    @ObservedObject var viewModel: DocumentsViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if viewModel.maintenanceRecords.isEmpty {
                    
                    ContentUnavailableView(
                        "No Maintenance Records",
                        systemImage: "wrench.and.screwdriver",
                        description: Text(
                            "Record maintenance for a vehicle before attaching service evidence."
                        )
                    )
                    
                } else {
                    
                    List(
                        viewModel.maintenanceRecords
                    ) { record in
                        
                        Button {
                            
                            let succeeded = viewModel.attach(
                                document: document,
                                to: record
                            )
                            
                            if succeeded {
                                dismiss()
                            }
                            
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
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Attach Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(
                "Unable to Attach Document",
                isPresented: Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: { isPresented in
                        if !isPresented {
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
