import SwiftUI
import Foundation
import TrafficRestrictionKit
import UIKit

class ContentView: ObservableObject {
    @Published var selectedCity = "北京"
    @Published var todayRestriction: String = "获取中..."
    @Published var weekRestrictions: [DateRestriction] = []
    let availableCities = ["北京"]
    
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue:.main) { [weak self] _ in
            self?.fetchData()
        }
    }
    
    func fetchData() {
        let manager = TrafficRestrictionManager()
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.todayRestriction = manager.getCurrentDateRestriction(currentDate : Date())
                let tomorrowDate = Calendar.current.date(byAdding:.day, value: 1, to: Date())!
                self.weekRestrictions = manager.getNextWeekRestrictions(currentDate: tomorrowDate)
            }
        }
    }
    
    func yesterdayRestriction() -> String {
        let manager = TrafficRestrictionManager()
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding:.day, value: -1, to: Date()) {
            return manager.getCurrentDateRestriction(currentDate : yesterday)
        }
        return "不限行"
    }
    
    func tomorrowRestriction() -> String {
        let manager = TrafficRestrictionManager()
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding:.day, value: 1, to: Date()) {
            return manager.getCurrentDateRestriction(currentDate : tomorrow)
        }
        return "不限行"
    }
}

struct ContentViewWrapper: View {
    @ObservedObject var viewModel = ContentView()
    
    var body: some View {
        ZStack {
            // 使用二次元风格的背景图片
            Image("animeBackground")
               .resizable()
               .scaledToFill()
               .frame(minWidth: 0, maxWidth:.infinity, minHeight: 0, maxHeight:.infinity)
               .clipped()
               .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // 标题
                    Text("北京小汽车尾号限行")
                       .font(.custom("Comic Sans MS", size: 24))
                       .foregroundColor(.white)
                       .shadow(color:.black.opacity(0.5), radius: 3, x: 1, y: 1)
                       .padding(.bottom, 10)
                    
                    // 今日、昨日、明日限行信息布局
                    HStack {
                        // 昨日限行
                        VStack(spacing: 5) {
                            Text(viewModel.dateFormatter.string(from: Calendar.current.date(byAdding:.day, value: -1, to: Date()) ?? Date()))
                               .font(.custom("Comic Sans MS", size: 14))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text(viewModel.yesterdayRestriction())
                               .font(.custom("Comic Sans MS", size: 18))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                       .padding(.horizontal, 12)
                       .padding(.vertical, 10)
                       .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.8).opacity(0.7), Color(red: 0.8, green: 0.2, blue: 0.8).opacity(0.7)]),
                                startPoint:.topLeading,
                                endPoint:.bottomTrailing
                            )
                        )
                       .cornerRadius(10)
                       .shadow(color:.black.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        Spacer()
                        
                        // 今日限行
                        VStack(spacing: 10) {
                            Text(viewModel.dateFormatter.string(from: Date()))
                               .font(.custom("Comic Sans MS", size: 18))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text("\(viewModel.dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1])")
                               .font(.custom("Comic Sans MS", size: 18))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text(viewModel.todayRestriction)
                               .font(.custom("Comic Sans MS", size: 36))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 3, x: 1, y: 1)
                        }
                       .padding(.horizontal, 20)
                       .padding(.vertical, 14)
                       .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.8).opacity(0.7), Color(red: 0.8, green: 0.2, blue: 0.8).opacity(0.7)]),
                                startPoint:.topLeading,
                                endPoint:.bottomTrailing
                            )
                        )
                       .cornerRadius(14)
                       .shadow(color:.black.opacity(0.5), radius: 5, x: 0, y: 3)
                        
                        Spacer()
                        
                        // 明日限行
                        VStack(spacing: 5) {
                            Text(viewModel.dateFormatter.string(from: Calendar.current.date(byAdding:.day, value: 1, to: Date()) ?? Date()))
                               .font(.custom("Comic Sans MS", size: 14))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            Text(viewModel.tomorrowRestriction())
                               .font(.custom("Comic Sans MS", size: 18))
                               .foregroundColor(.white)
                               .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        }
                       .padding(.horizontal, 12)
                       .padding(.vertical, 10)
                       .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.8).opacity(0.7), Color(red: 0.8, green: 0.2, blue: 0.8).opacity(0.7)]),
                                startPoint:.topLeading,
                                endPoint:.bottomTrailing
                            )
                        )
                       .cornerRadius(10)
                       .shadow(color:.black.opacity(0.5), radius: 3, x: 0, y: 2)
                    }
                    
                    // 一周限行信息列表
                    VStack(spacing: 0) {
                        ForEach(viewModel.weekRestrictions) { restriction in
                            HStack {
                                VStack(alignment:.leading, spacing: 6) {
                                    if let date = viewModel.dateFormatter.date(from: restriction.date) {
                                        Text(viewModel.dateFormatter.string(from: date))
                                           .font(.custom("Comic Sans MS", size: 16))
                                           .foregroundColor(.white)
                                           .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                        Text("\(viewModel.dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])")
                                           .font(.custom("Comic Sans MS", size: 16))
                                           .foregroundColor(.white)
                                           .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                    }
                                }
                                Spacer()
                                Text(restriction.restriction)
                                   .font(.custom("Comic Sans MS", size: 20))
                                   .foregroundColor(.white)
                                   .shadow(color:.black.opacity(0.5), radius: 2, x: 1, y: 1)
                            }
                           .padding(.horizontal, 20)
                           .padding(.vertical, 14)
                           .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.6).opacity(0.7), Color(red: 0.6, green: 0.1, blue: 0.6).opacity(0.7)]),
                                    startPoint:.topLeading,
                                    endPoint:.bottomTrailing
                                )
                            )
                           .cornerRadius(0)
                           .shadow(color:.black.opacity(0.5), radius: 5, x: 0, y: 3)
                            if !restriction.date.isEmpty {
                                Divider()
                                   .background(Color.white.opacity(0.5))
                                   .padding(.horizontal, 20)
                            }
                        }
                    }
                }
               .padding(20)
               .padding(.top, 60)
            }
        }
       .onAppear {
            viewModel.fetchData()
        }
    }
}
