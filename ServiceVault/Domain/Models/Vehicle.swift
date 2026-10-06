//
//  Vehicle.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct Vehicle: Identifiable, Equatable {
    let id: UUID
    var make: String
    var model: String
    var year: Int
    var registration: String
    var currentOdometer: Int

    var displayName: String {
        "\(year) \(make) \(model)"
    }
}
