//
//  WidgetSnapshotStore.swift
//  ServiceVault
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import Foundation

struct WidgetSnapshotStore {

    static let appGroupID =
        "group.com.jovansutardi.ServiceVault"

    private static let key =
        "serviceVaultWidgetSnapshot"

    static func save(_ snapshot: WidgetSnapshot) {
        guard
            let defaults = UserDefaults(
                suiteName: appGroupID
            ),
            let data = try? JSONEncoder().encode(snapshot)
        else {
            return
        }

        defaults.set(
            data,
            forKey: key
        )
    }

    static func load() -> WidgetSnapshot? {
        guard
            let defaults = UserDefaults(
                suiteName: appGroupID
            ),
            let data = defaults.data(
                forKey: key
            )
        else {
            return nil
        }

        return try? JSONDecoder().decode(
            WidgetSnapshot.self,
            from: data
        )
    }
}
