//
//  ReviewUpcomingMaintenanceUseCaseTests.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import XCTest
@testable import ServiceVault

final class ReviewUpcomingMaintenanceUseCaseTests: XCTestCase {

    func testVehicleNotFoundIsRejected() {

        let vehicleRepository = MockVehicleRepository()
        let maintenanceRepository = MockMaintenanceRepository()

        let useCase = ReviewUpcomingMaintenanceUseCase(
            vehicleRepository: vehicleRepository,
            maintenanceRepository: maintenanceRepository
        )

        XCTAssertThrowsError(
            try useCase.execute(vehicleID: UUID())
        ) { error in

            XCTAssertEqual(
                error as? UpcomingMaintenanceError,
                .vehicleNotFound
            )
        }
    }

    func testMaintenanceDueWithinThirtyDaysIsReturned() throws {

        let vehicleID = UUID()

        let vehicleRepository = MockVehicleRepository()
        let maintenanceRepository = MockMaintenanceRepository()

        vehicleRepository.storedVehicles = [
            Vehicle(
                id: vehicleID,
                make: "BMW",
                model: "X3 M40i",
                year: 2022,
                registration: "ABC123",
                currentOdometer: 60_000
            )
        ]

        maintenanceRepository.storedRecords = [
            MaintenanceRecord(
                id: UUID(),
                vehicleID: vehicleID,
                serviceType: "Brake Fluid",
                serviceDate: Date(),
                odometer: 55_000,
                workshopName: "BMW Service Centre",
                cost: nil,
                notes: "",
                nextServiceDate: Calendar.current.date(
                    byAdding: .day,
                    value: 10,
                    to: Date()
                ),
                nextServiceOdometer: nil
            )
        ]

        let useCase = ReviewUpcomingMaintenanceUseCase(
            vehicleRepository: vehicleRepository,
            maintenanceRepository: maintenanceRepository
        )

        let results = try useCase.execute(
            vehicleID: vehicleID
        )

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.serviceType, "Brake Fluid")
    }
}
