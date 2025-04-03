//
//  TodayWidgetBundle.swift
//  TodayWidget
//
//  Created by 萧瑟(吴建强) on 2025/4/2.
//

import WidgetKit
import SwiftUI

@main
struct TodayWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodayAndTomorrowWidget()
        TodayWidgetLiveActivity()
    }
}
