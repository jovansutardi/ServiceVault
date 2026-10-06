//
//  PersistenceController.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ServiceVault")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError(
                    "Failed to load Core Data: \(error.localizedDescription)"
                )
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
