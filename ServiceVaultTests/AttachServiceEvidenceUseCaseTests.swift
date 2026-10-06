//
//  AttachServiceEvidenceUseCaseTests.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import XCTest
@testable import ServiceVault

final class AttachServiceEvidenceUseCaseTests: XCTestCase {

    func testValidPDFDocumentIsSaved() throws {

        let repository = MockServiceDocumentRepository()

        let useCase = AttachServiceEvidenceUseCase(
            repository: repository
        )

        let document = try useCase.execute(
            maintenanceRecordID: UUID(),
            title: "Major Service Invoice",
            fileName: "invoice.pdf"
        )

        XCTAssertEqual(repository.storedDocuments.count, 1)
        XCTAssertEqual(document.title, "Major Service Invoice")
    }

    func testUnsupportedDocumentIsRejected() {

        let repository = MockServiceDocumentRepository()

        let useCase = AttachServiceEvidenceUseCase(
            repository: repository
        )

        XCTAssertThrowsError(
            try useCase.execute(
                maintenanceRecordID: UUID(),
                title: "Invoice",
                fileName: "invoice.exe"
            )
        ) { error in

            XCTAssertEqual(
                error as? ServiceEvidenceError,
                .unsupportedDocument
            )
        }
    }
}
