//
//  ShareViewController.swift
//  ServiceVaultShare
//
//  Created by Jovan Sutardi on 6/10/2026.
//

import UIKit
import Social
import UniformTypeIdentifiers

final class ShareViewController:
    SLComposeServiceViewController {

    private var importedSuccessfully = false

    override func isContentValid() -> Bool {
        true
    }

    override func didSelectPost() {

        guard
            let extensionItem =
                extensionContext?
                    .inputItems
                    .first as? NSExtensionItem,
            let provider =
                extensionItem
                    .attachments?
                    .first
        else {
            finish()
            return
        }

        importItem(from: provider)
    }

    private func importItem(
        from provider: NSItemProvider
    ) {

        let supportedTypes = [
            UTType.pdf,
            UTType.image,
            UTType.data
        ]

        guard let type =
                supportedTypes.first(
                    where: {
                        provider.hasItemConformingToTypeIdentifier(
                            $0.identifier
                        )
                    }
                )
        else {
            finish()
            return
        }

        provider.loadFileRepresentation(
            forTypeIdentifier: type.identifier
        ) { url, error in

            guard
                error == nil,
                let url
            else {
                self.finish()
                return
            }

            do {

                _ = try AppGroupImportedDocumentStore
                    .shared
                    .saveImportedFile(
                        temporaryURL: url
                    )

                self.importedSuccessfully = true

            } catch {
                print(
                    "ServiceVault import failed: \(error)"
                )
            }

            self.finish()
        }
    }

    private func finish() {

        DispatchQueue.main.async {

            self.extensionContext?
                .completeRequest(
                    returningItems: nil,
                    completionHandler: nil
                )
        }
    }

    override func configurationItems()
        -> [Any]! {
        []
    }
}
