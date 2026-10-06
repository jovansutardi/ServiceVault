//
//  ServiceVaultWidgetLiveActivity.swift
//  ServiceVaultWidget
//
//  Created by Jovan Sutardi on 5/10/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ServiceVaultWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ServiceVaultWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ServiceVaultWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ServiceVaultWidgetAttributes {
    fileprivate static var preview: ServiceVaultWidgetAttributes {
        ServiceVaultWidgetAttributes(name: "World")
    }
}

extension ServiceVaultWidgetAttributes.ContentState {
    fileprivate static var smiley: ServiceVaultWidgetAttributes.ContentState {
        ServiceVaultWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ServiceVaultWidgetAttributes.ContentState {
         ServiceVaultWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ServiceVaultWidgetAttributes.preview) {
   ServiceVaultWidgetLiveActivity()
} contentStates: {
    ServiceVaultWidgetAttributes.ContentState.smiley
    ServiceVaultWidgetAttributes.ContentState.starEyes
}
