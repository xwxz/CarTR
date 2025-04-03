//
//  TodayWidgetLiveActivity.swift
//  TodayWidget
//
//  Created by 萧瑟(吴建强) on 2025/4/2.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TodayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TodayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodayWidgetAttributes.self) { context in
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

extension TodayWidgetAttributes {
    fileprivate static var preview: TodayWidgetAttributes {
        TodayWidgetAttributes(name: "World")
    }
}

extension TodayWidgetAttributes.ContentState {
    fileprivate static var smiley: TodayWidgetAttributes.ContentState {
        TodayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TodayWidgetAttributes.ContentState {
         TodayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TodayWidgetAttributes.preview) {
   TodayWidgetLiveActivity()
} contentStates: {
    TodayWidgetAttributes.ContentState.smiley
    TodayWidgetAttributes.ContentState.starEyes
}
