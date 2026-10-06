//
//  RecordVehicleMaintenanceUseCaseTests.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import XCTest
@testable import ServiceVault

final class RecordVehicleMaintenanceUseCaseTests: XCTestCase {

    private var repository: MockMaintenanceRepository!
    private var useCase: RecordVehicleMaintenanceUseCase!

    override func setUp() {
        super.setUp()

        repository = MockMaintenanceRepository()

        useCase = RecordVehicleMaintenanceUseCase(
            repository: repository
        )
    }

    func testValidMaintenanceRecordIsSaved() throws {

        let vehicleID = UUID()

        let record = try useCase.execute(
            vehicleID: vehicleID,
            serviceType: "Oil and Filter Service",
            serviceDate: Date(),
            odometer: 50_000,
            workshopName: "BMW Service Centre",
            cost: 350,
            notes: "",
            nextServiceDate: nil,
            nextServiceOdometer: 60_000
        )

        XCTAssertEqual(repository.storedRecords.count, 1)
        XCTAssertEqual(record.serviceType, "Oil and Filter Service")
        XCTAssertEqual(record.odometer, 50_000)
    }

    func testMaintenanceWithoutServiceTypeIsRejected() {

        XCTAssertThrowsError(
            try useCase.execute(
                vehicleID: UUID(),
                serviceType: "",
                serviceDate: Date(),
                odometer: 50_000,
                workshopName: "",
                cost: nil,
                notes: "",
                nextServiceDate: nil,
                nextServiceOdometer: nil
            )
        ) { error in

            XCTAssertEqual(
                error as? RecordMaintenanceError,
                .missingServiceType
            )
        }
    }

    func testFutureMaintenanceDateIsRejected() {

        let tomorrow = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Date()
        )!

        XCTAssertThrowsError(
            try useCase.execute(
                vehicleID: UUID(),
                serviceType: "Brake Fluid",
                serviceDate: tomorrow,
                odometer: 50_000,
                workshopName: "",
                cost: nil,
                notes: "",
                nextServiceDate: nil,
                nextServiceOdometer: nil
            )
        ) { error in

            XCTAssertEqual(
                error as? RecordMaintenanceError,
                .futureServiceDate
            )
        }
    }

    func testNegativeOdometerReadingIsRejected() {

        XCTAssertThrowsError(
            try useCase.execute(
                vehicleID: UUID(),
                serviceType: "Oil Service",
                serviceDate: Date(),
                odometer: -1,
                workshopName: "",
                cost: nil,
                notes: "",
                nextServiceDate: nil,
                nextServiceOdometer: nil
            )
        ) { error in

            XCTAssertEqual(
                error as? RecordMaintenanceError,
                .invalidOdometer
            )
        }
    }

    func testOdometerBelowPreviousServiceRecordIsRejected() throws {

        let vehicleID = UUID()

        let previousRecord = MaintenanceRecord(
            id: UUID(),
            vehicleID: vehicleID,
            serviceType: "Major Service",
            serviceDate: Date().addingTimeInterval(-86_400),
            odometer: 60_000,
            workshopName: "Workshop",
            cost: nil,
            notes: "",
            nextServiceDate: nil,
            nextServiceOdometer: nil
        )

        try repository.save(previousRecord)

        XCTAssertThrowsError(
            try useCase.execute(
                vehicleID: vehicleID,
                serviceType: "Oil Service",
                serviceDate: Date(),
                odometer: 55_000,
                workshopName: "",
                cost: nil,
                notes: "",
                nextServiceDate: nil,
                nextServiceOdometer: nil
            )
        ) { error in

            XCTAssertEqual(
                error as? RecordMaintenanceError,
                .odometerEarlierThanPreviousRecord
            )
        }
    }
}
