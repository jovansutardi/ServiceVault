//
//  RecordMaintenanceError.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

enum RecordMaintenanceError: LocalizedError, Equatable {
    case missingServiceType
    case futureServiceDate
    case invalidOdometer
    case odometerEarlierThanPreviousRecord

    var errorDescription: String? {
        switch self {
        case .missingServiceType:
            return "Choose the maintenance work that was completed."

        case .futureServiceDate:
            return "A completed service cannot have a future date. Check the service date and try again."

        case .invalidOdometer:
            return "Enter a valid odometer reading."

        case .odometerEarlierThanPreviousRecord:
            return "This odometer reading is lower than your previous service record. Check the reading before saving."
        }
    }
}
