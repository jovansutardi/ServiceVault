//
//  DocumentsViewModel.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import Foundation
import Combine

@MainActor
final class DocumentsViewModel: ObservableObject {

    @Published var documents: [ImportedServiceDocument] = []
    @Published var maintenanceRecords: [MaintenanceRecord] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let store: AppGroupImportedDocumentStore
    private let vehicleRepository: VehicleRepository
    private let maintenanceRepository: MaintenanceRepository
    private let attachServiceEvidenceUseCase: AttachServiceEvidenceUseCase

    init(
        store: AppGroupImportedDocumentStore,
        vehicleRepository: VehicleRepository,
        maintenanceRepository: MaintenanceRepository,
        attachServiceEvidenceUseCase: AttachServiceEvidenceUseCase
    ) {
        self.store = store
        self.vehicleRepository = vehicleRepository
        self.maintenanceRepository = maintenanceRepository
        self.attachServiceEvidenceUseCase = attachServiceEvidenceUseCase
    }

    func loadDocuments() {
        documents = store.fetchPendingDocuments()
    }

    func loadMaintenanceRecords() {
        do {
            let vehicles = try vehicleRepository.fetchVehicles()

            var allRecords: [MaintenanceRecord] = []

            for vehicle in vehicles {
                let records = try maintenanceRepository.records(
                    for: vehicle.id
                )

                allRecords.append(contentsOf: records)
            }

            maintenanceRecords = allRecords.sorted {
                $0.serviceDate > $1.serviceDate
            }

            errorMessage = nil

        } catch {
            errorMessage =
                "Your maintenance records could not be loaded. Please try again."
        }
    }

    @discardableResult
    func attach(
        document: ImportedServiceDocument,
        to maintenanceRecord: MaintenanceRecord
    ) -> Bool {

        errorMessage = nil

        do {
            _ = try attachServiceEvidenceUseCase.execute(
                maintenanceRecordID: maintenanceRecord.id,
                title: document.fileName,
                fileName: document.storedFileName,
                importedDate: document.importedDate
            )

            try store.markProcessed(document)

            loadDocuments()

            successMessage =
                "The service document was attached successfully."

            return true

        } catch {
            errorMessage = error.localizedDescription
            print("ATTACH ERROR:", error)
            return false
        }
    }

    func removeDocument(
        _ document: ImportedServiceDocument
    ) {
        do {
            try store.remove(document)
            loadDocuments()

        } catch {
            errorMessage =
                "This imported document could not be removed. Please try again."
        }
    }
}
