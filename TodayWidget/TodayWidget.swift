import WidgetKit
import SwiftUI
import TrafficRestrictionKit

// 定义Widget展示的数据
struct TodayAndTomorrowWidgetEntry: TimelineEntry {
    let date: Date
    let todayRestriction: String
    let tomorrowRestriction: String
}

// 提供Timeline数据
struct TodayAndTomorrowWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayAndTomorrowWidgetEntry {
        return TodayAndTomorrowWidgetEntry(
            date: Date(),
            todayRestriction: "暂无数据",
            tomorrowRestriction: "暂无数据"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayAndTomorrowWidgetEntry) -> ()) {
        let entry = TodayAndTomorrowWidgetEntry(
            date: Date(),
            todayRestriction: "今日限行\n3和8",
            tomorrowRestriction: "明日限行\n0和5"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayAndTomorrowWidgetEntry>) -> ()) {
        var entries: [TodayAndTomorrowWidgetEntry] = []
        let currentDate = Date()
        let todayRestriction = getRestrictionForDate(currentDate)
        let tomorrowDate = Calendar.current.date(byAdding:.day, value: 1, to: currentDate)!
        let tomorrowRestriction = getRestrictionForDate(tomorrowDate)
        
        let entry = TodayAndTomorrowWidgetEntry(
            date: currentDate,
            todayRestriction: todayRestriction,
            tomorrowRestriction: tomorrowRestriction
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy:.after(currentDate))
        completion(timeline)
    }
    
    func getRestrictionForDate(_ date: Date) -> String {
        let manager = TrafficRestrictionManager()
        return manager.getCurrentDateRestriction(currentDate: date)
    }
}

// Widget视图
struct TodayAndTomorrowWidgetView: View {
    var entry: TodayAndTomorrowWidgetEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    Text("今天限行")
                       .font(.system(size: 20, weight:.bold, design:.rounded))
                       .foregroundColor(.white)
                       .shadow(color:.white.opacity(0.5), radius: 2, x: 0, y: 1)
                    Text(entry.todayRestriction)
                       .font(.system(size: 36, weight:.bold, design:.rounded))
                       .foregroundColor(.white)
                       .shadow(color:.white.opacity(0.5), radius: 3, x: 0, y: 1)
                }
               .padding(14)
               .frame(maxWidth:.infinity)
               .background(
                    LinearGradient(
                        colors: [Color.green.opacity(0.8), Color.gray.opacity(0.8)],
                        startPoint:.topLeading,
                        endPoint:.bottomTrailing
                    )
                )
               .cornerRadius(20)
               .shadow(color:.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    
                VStack(spacing: 8) {
                    Text("明天限行")
                       .font(.system(size: 20, weight:.bold, design:.rounded))
                       .foregroundColor(.white)
                       .shadow(color:.white.opacity(0.5), radius: 2, x: 0, y: 1)
                    Text(entry.tomorrowRestriction)
                       .font(.system(size: 36, weight:.bold, design:.rounded))
                       .foregroundColor(.white)
                       .shadow(color:.white.opacity(0.5), radius: 3, x: 0, y: 1)
                }
               .padding(14)
               .frame(maxWidth:.infinity)
               .background(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.8), Color.gray.opacity(0.8)],
                        startPoint:.topLeading,
                        endPoint:.bottomTrailing
                    )
                )
               .cornerRadius(20)
               .shadow(color:.black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
        }
       .frame(maxWidth:.infinity, maxHeight:.infinity)
       .containerBackground(
            LinearGradient(
                colors: [Color(red: 0.2, green: 0.8, blue: 0.6), Color(red: 0.8, green: 0.2, blue: 0.6)],
                startPoint:.topLeading,
                endPoint:.bottomTrailing
            ),
            for:.widget
        )
       .cornerRadius(20)
    }
}

// 定义Widget
struct TodayAndTomorrowWidget: Widget {
    let kind: String = "TodayAndTomorrowWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayAndTomorrowWidgetProvider()) { entry in
            TodayAndTomorrowWidgetView(entry: entry)
        }
       .configurationDisplayName("今日和明日限行")
       .description("显示今日和明日汽车限行尾号信息")
       .supportedFamilies([.systemMedium])
    }
}
