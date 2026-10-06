//
//  ServiceEvidenceError.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

enum ServiceEvidenceError: LocalizedError, Equatable {
    case missingTitle
    case unsupportedDocument
    case duplicateDocument

    var errorDescription: String? {
        switch self {
        case .missingTitle:
            return "Give this service document a name before attaching it."

        case .unsupportedDocument:
            return "This document type is not supported. Choose a PDF, JPG, JPEG, or PNG file."

        case .duplicateDocument:
            return "This document is already attached to the selected maintenance record."
        }
    }
}
