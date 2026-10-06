//
//  CoreDataMaintenanceRepositoryTests.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 7/10/2026.
//

import XCTest
import CoreData
@testable import ServiceVault

final class CoreDataMaintenanceRepositoryTests: XCTestCase {

    func testRecordsReturnsOnlySelectedVehicleRecords() throws {

        let persistence = PersistenceController(
            inMemory: true
        )

        let context =
            persistence.container.viewContext

        let vehicleRepository =
            CoreDataVehicleRepository(
                context: context
            )

        let maintenanceRepository =
            CoreDataMaintenanceRepository(
                context: context
            )

        let firstVehicle = Vehicle(
            id: UUID(),
            make: "BMW",
            model: "X3",
            year: 2022,
            registration: "BMW123",
            currentOdometer: 50_000
        )

        let secondVehicle = Vehicle(
            id: UUID(),
            make: "Toyota",
            model: "Corolla",
            year: 2020,
            registration: "TOY123",
            currentOdometer: 40_000
        )

        try vehicleRepository.save(
            firstVehicle
        )

        try vehicleRepository.save(
            secondVehicle
        )

        let firstRecord =
            MaintenanceRecord(
                id: UUID(),
                vehicleID:
                    firstVehicle.id,
                serviceType:
                    "Oil Service",
                serviceDate:
                    Date(),
                odometer:
                    50_000,
                workshopName:
                    "BMW Sydney",
                cost:
                    300,
                notes:
                    "",
                nextServiceDate:
                    nil,
                nextServiceOdometer:
                    nil
            )

        let secondRecord =
            MaintenanceRecord(
                id: UUID(),
                vehicleID:
                    secondVehicle.id,
                serviceType:
                    "Brake Service",
                serviceDate:
                    Date(),
                odometer:
                    40_000,
                workshopName:
                    "Toyota Sydney",
                cost:
                    400,
                notes:
                    "",
                nextServiceDate:
                    nil,
                nextServiceOdometer:
                    nil
            )

        try maintenanceRepository.save(
            firstRecord
        )

        try maintenanceRepository.save(
            secondRecord
        )

        let results =
            try maintenanceRepository.records(
                for: firstVehicle.id
            )

        XCTAssertEqual(
            results.count,
            1
        )

        XCTAssertEqual(
            results.first?.serviceType,
            "Oil Service"
        )

        XCTAssertEqual(
            results.first?.vehicleID,
            firstVehicle.id
        )
    }
}

func testUpcomingMaintenanceReturnsRecordWithinOdometerThreshold() throws {

    let persistence = PersistenceController(
        inMemory: true
    )

    let context =
        persistence.container.viewContext

    let vehicleRepository =
        CoreDataVehicleRepository(
            context: context
        )

    let maintenanceRepository =
        CoreDataMaintenanceRepository(
            context: context
        )

    let vehicle = Vehicle(
        id: UUID(),
        make: "BMW",
        model: "X3",
        year: 2022,
        registration: "BMW123",
        currentOdometer: 64_120
    )

    try vehicleRepository.save(vehicle)

    let record =
        MaintenanceRecord(
            id: UUID(),
            vehicleID:
                vehicle.id,
            serviceType:
                "Oil Service",
            serviceDate:
                Date(),
            odometer:
                64_120,
            workshopName:
                "BMW Sydney",
            cost:
                350,
            notes:
                "",
            nextServiceDate:
                nil,
            nextServiceOdometer:
                64_500
        )

    try maintenanceRepository.save(record)

    let results =
        try maintenanceRepository.upcomingMaintenance(
            for: vehicle.id,
            currentOdometer:
                vehicle.currentOdometer,
            withinDays:
                30,
            withinKilometres:
                1_000
        )

    XCTAssertEqual(
        results.count,
        1
    )

    XCTAssertEqual(
        results.first?.id,
        record.id
    )
}
