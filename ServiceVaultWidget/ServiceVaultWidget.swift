//
//  ServiceVaultWidget.swift
//  ServiceVaultWidget
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import WidgetKit
import SwiftUI

struct ServiceVaultEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot?
}

struct ServiceVaultProvider: TimelineProvider {

    func placeholder(in context: Context) -> ServiceVaultEntry {
        ServiceVaultEntry(
            date: Date(),
            snapshot: WidgetSnapshot(
                vehicleName: "2022 BMW X3 M40i",
                nextServiceDate: Calendar.current.date(
                    byAdding: .day,
                    value: 10,
                    to: Date()
                ),
                nextServiceOdometer: 65_000,
                currentOdometer: 64_120,
                urgentMaintenanceCount: 1
            )
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (ServiceVaultEntry) -> Void
    ) {
        completion(
            ServiceVaultEntry(
                date: Date(),
                snapshot: WidgetSnapshotStore.load()
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ServiceVaultEntry>) -> Void
    ) {
        let entry = ServiceVaultEntry(
            date: Date(),
            snapshot: WidgetSnapshotStore.load()
        )

        let refreshDate = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: Date()
        ) ?? Date()

        completion(
            Timeline(
                entries: [entry],
                policy: .after(refreshDate)
            )
        )
    }
}

struct ServiceVaultWidgetView: View {

    let entry: ServiceVaultEntry

    @Environment(\.widgetFamily)
    private var family

    var body: some View {
        if let snapshot = entry.snapshot {
            switch family {
            case .systemSmall:
                smallWidget(snapshot)

            default:
                mediumWidget(snapshot)
            }
        } else {
            VStack(spacing: 8) {
                Image(systemName: "car.fill")
                    .font(.title2)

                Text("No Vehicle")
                    .font(.headline)

                Text("Open ServiceVault to add a vehicle.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }

    private func smallWidget(
        _ snapshot: WidgetSnapshot
    ) -> some View {

        let kilometresRemaining: Int? = {
            guard let nextOdometer = snapshot.nextServiceOdometer else {
                return nil
            }

            return max(
                nextOdometer - snapshot.currentOdometer,
                0
            )
        }()

        return VStack(
            alignment: .leading,
            spacing: 6
        ) {

            Text("SERVICEVAULT")
                .font(.caption2)
                .fontWeight(.semibold)

            Text(snapshot.vehicleName)
                .font(.headline)
                .lineLimit(2)

            Spacer()

            if let kilometresRemaining {
                Text("NEXT SERVICE")
                    .font(.caption2)

                Text("\(kilometresRemaining.formatted()) km")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding()
    }

    private func mediumWidget(
        _ snapshot: WidgetSnapshot
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(snapshot.vehicleName)
                .font(.headline)

            if let date = snapshot.nextServiceDate {
                let formattedDate = date.formatted(
                    date: .abbreviated,
                    time: .omitted
                )

                Label(
                    "Due \(formattedDate)",
                    systemImage: "calendar"
                )
            }

            if let odometer = snapshot.nextServiceOdometer {
                let formattedOdometer = odometer.formatted()

                Label(
                    "Due at \(formattedOdometer) km",
                    systemImage: "gauge.with.dots.needle.50percent"
                )
            }

            Spacer()

            Text(
                "\(snapshot.urgentMaintenanceCount) maintenance item(s) requiring attention"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct ServiceVaultWidget: Widget {

    let kind = "ServiceVaultWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ServiceVaultProvider()
        ) { entry in
            ServiceVaultWidgetView(
                entry: entry
            )
            .containerBackground(
                .fill.tertiary,
                for: .widget
            )
        }
        .configurationDisplayName(
            "ServiceVault Maintenance"
        )
        .description(
            "See your next vehicle maintenance requirement."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}
