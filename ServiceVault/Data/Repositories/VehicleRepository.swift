//
//  VehicleRepository.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

protocol VehicleRepository {
    func save(_ vehicle: Vehicle) throws

    func fetchVehicles() throws -> [Vehicle]

    func findVehicle(id: UUID) throws -> Vehicle?
}
