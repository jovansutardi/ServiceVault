//
//  MockVehicleRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation
@testable import ServiceVault

final class MockVehicleRepository: VehicleRepository {

    var storedVehicles: [Vehicle] = []

    func save(_ vehicle: Vehicle) throws {
        storedVehicles.append(vehicle)
    }

    func fetchVehicles() throws -> [Vehicle] {
        storedVehicles
    }

    func findVehicle(id: UUID) throws -> Vehicle? {
        storedVehicles.first { $0.id == id }
    }
}
