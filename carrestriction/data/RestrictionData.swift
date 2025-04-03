//
//  RestrictionData.swift
//  carrestriction
//
//  Created by 萧瑟(吴建强) on 2025/4/2.
//

import Foundation

struct DateRestriction: Identifiable{
    var id = UUID()
    let date: String
    let restriction: String
}

// 定义限行规则结构体
struct TrafficRestrictionRule {
    let startDate: Date
    let endDate: Date
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
}

// 解析图片数据生成规则数组
let trafficRestrictionRules: [TrafficRestrictionRule] = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy年MM月dd日"

    let rule1 = TrafficRestrictionRule(
        startDate: dateFormatter.date(from: "2025年3月31日")!,
        endDate: dateFormatter.date(from: "2025年6月29日")!,
        monday: "1和6",
        tuesday: "2和7",
        wednesday: "3和8",
        thursday: "4和9",
        friday: "5和0"
    )
    let rule2 = TrafficRestrictionRule(
        startDate: dateFormatter.date(from: "2025年6月30日")!,
        endDate: dateFormatter.date(from: "2025年9月28日")!,
        monday: "5和0",
        tuesday: "1和6",
        wednesday: "2和7",
        thursday: "3和8",
        friday: "4和9"
    )
    let rule3 = TrafficRestrictionRule(
        startDate: dateFormatter.date(from: "2025年9月29日")!,
        endDate: dateFormatter.date(from: "2025年12月28日")!,
        monday: "4和9",
        tuesday: "5和0",
        wednesday: "1和6",
        thursday: "2和7",
        friday: "3和8"
    )
    let rule4 = TrafficRestrictionRule(
        startDate: dateFormatter.date(from: "2025年12月29日")!,
        endDate: dateFormatter.date(from: "2026年3月29日")!,
        monday: "3和8",
        tuesday: "4和9",
        wednesday: "5和0",
        thursday: "1和6",
        friday: "2和7"
    )

    return [rule1, rule2, rule3, rule4]
}()

// 第一个方法：返回当前日期对应的限行数据
func getCurrentDateRestriction(currentDate: Date) -> String {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: currentDate)
    for rule in trafficRestrictionRules {
        if currentDate >= rule.startDate && currentDate <= rule.endDate {
            switch weekday {
            case 2: return rule.monday
            case 3: return rule.tuesday
            case 4: return rule.wednesday
            case 5: return rule.thursday
            case 6: return rule.friday
            default: return "不限行"
            }
        }
    }
    return "不限行"
}

// 第二个方法：返回未来一周的限行数据
func getNextWeekRestrictions(currentDate: Date) -> [DateRestriction] {
    var result: [DateRestriction] = []
    let calendar = Calendar.current
    var current = currentDate
    for _ in 0..<7 {
        let weekday = calendar.component(.weekday, from: current)
        for rule in trafficRestrictionRules {
            if current >= rule.startDate && current <= rule.endDate {
                var restriction = ""
                switch weekday {
                case 2: restriction = rule.monday
                case 3: restriction = rule.tuesday
                case 4: restriction = rule.wednesday
                case 5: restriction = rule.thursday
                case 6: restriction = rule.friday
                default: restriction = "不限行"
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateStr = dateFormatter.string(from: current)
                let dr = DateRestriction(date: dateStr, restriction: restriction);
                result.append(dr)
            }
        }
        if let nextDay = calendar.date(byAdding:.day, value: 1, to: current) {
            current = nextDay
        } else {
            break
        }
    }
    return result
}


func weekday(from date: Date) -> String {
   let calendar = Calendar.current
    let components = calendar.dateComponents([.weekday], from: date)
   let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
   return weekdays[components.weekday! - 1]
}
