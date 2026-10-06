//
//  WidgetSnapshot.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct WidgetSnapshot: Codable {
    let vehicleName: String
    let nextServiceDate: Date?
    let nextServiceOdometer: Int?
    let currentOdometer: Int
    let urgentMaintenanceCount: Int
}
