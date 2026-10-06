//
//  AppContainer.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
import CoreData

final class AppContainer {

    static let shared = AppContainer()

    let persistenceController: PersistenceController

    let vehicleRepository: VehicleRepository
    let maintenanceRepository: MaintenanceRepository
    let serviceDocumentRepository: ServiceDocumentRepository

    let recordVehicleMaintenanceUseCase: RecordVehicleMaintenanceUseCase
    let reviewUpcomingMaintenanceUseCase: ReviewUpcomingMaintenanceUseCase
    let attachServiceEvidenceUseCase: AttachServiceEvidenceUseCase
    
    let widgetSyncService: WidgetSyncService

    private init() {

        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext

        let vehicleRepository =
            CoreDataVehicleRepository(context: context)

        let maintenanceRepository =
            CoreDataMaintenanceRepository(context: context)

        let serviceDocumentRepository =
            CoreDataServiceDocumentRepository(context: context)

        self.persistenceController = persistenceController

        self.vehicleRepository = vehicleRepository
        self.maintenanceRepository = maintenanceRepository
        self.serviceDocumentRepository = serviceDocumentRepository

        self.recordVehicleMaintenanceUseCase =
            RecordVehicleMaintenanceUseCase(
                repository: maintenanceRepository
            )

        self.reviewUpcomingMaintenanceUseCase =
            ReviewUpcomingMaintenanceUseCase(
                vehicleRepository: vehicleRepository,
                maintenanceRepository: maintenanceRepository
            )

        self.attachServiceEvidenceUseCase =
            AttachServiceEvidenceUseCase(
                repository: serviceDocumentRepository
            )
        
        self.widgetSyncService = WidgetSyncService(
            vehicleRepository: vehicleRepository,
            maintenanceRepository: maintenanceRepository
        )
    }
}
