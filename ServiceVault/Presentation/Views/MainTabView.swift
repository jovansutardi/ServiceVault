//
//  MainTabView.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import SwiftUI

struct MainTabView: View {

    private let container = AppContainer.shared

    var body: some View {

        TabView {

            GarageView(
                vehicleRepository:
                    container.vehicleRepository,
                widgetSyncService:
                    container.widgetSyncService
            )
            .tabItem {
                Label(
                    "Garage",
                    systemImage: "car.fill"
                )
            }

            UpcomingMaintenanceView(
                vehicleRepository:
                    container.vehicleRepository,
                reviewUpcomingMaintenanceUseCase:
                    container.reviewUpcomingMaintenanceUseCase
            )
            .tabItem {
                Label(
                    "Maintenance",
                    systemImage:
                        "wrench.and.screwdriver.fill"
                )
            }

            ImportedDocumentsView(
                vehicleRepository:
                    container.vehicleRepository,
                maintenanceRepository:
                    container.maintenanceRepository,
                attachServiceEvidenceUseCase:
                    container.attachServiceEvidenceUseCase
            )
            .tabItem {
                Label(
                    "Documents",
                    systemImage: "doc.fill"
                )
            }
        }
    }
}
