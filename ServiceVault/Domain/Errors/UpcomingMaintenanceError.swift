//
//  UpcomingMaintenanceError.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

enum UpcomingMaintenanceError: LocalizedError, Equatable {
    case vehicleNotFound
    case invalidReviewPeriod

    var errorDescription: String? {
        switch self {
        case .vehicleNotFound:
            return "This vehicle could not be found. Return to your garage and select the vehicle again."

        case .invalidReviewPeriod:
            return "Choose a valid maintenance review period."
        }
    }
}
