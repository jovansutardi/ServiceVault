//
//  CoreDataVehicleRepositoryTests.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 7/10/2026.
//

import XCTest
import CoreData
@testable import ServiceVault

final class CoreDataVehicleRepositoryTests: XCTestCase {

    func testSavedVehicleCanBeFetched() throws {

        let persistence = PersistenceController(
            inMemory: true
        )

        let repository = CoreDataVehicleRepository(
            context: persistence.container.viewContext
        )

        let vehicle = Vehicle(
            id: UUID(),
            make: "BMW",
            model: "X3 M40i",
            year: 2022,
            registration: "ABC123",
            currentOdometer: 64_120
        )

        try repository.save(vehicle)

        let fetchedVehicles =
            try repository.fetchVehicles()

        XCTAssertEqual(
            fetchedVehicles.count,
            1
        )

        XCTAssertEqual(
            fetchedVehicles.first?.id,
            vehicle.id
        )

        XCTAssertEqual(
            fetchedVehicles.first?.make,
            "BMW"
        )

        XCTAssertEqual(
            fetchedVehicles.first?.model,
            "X3 M40i"
        )
    }
}
