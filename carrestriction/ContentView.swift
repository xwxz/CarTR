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
                self.weekRestrictions = manager.getNextWeekRestrictions(currentDate: Date())
            }
        }
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
            // 背景图片
            Image("backgroundImage")
               .resizable()
               .scaledToFill()
               .frame(minWidth: 0, maxWidth:.infinity, minHeight: 0, maxHeight:.infinity)
               .clipped()
               .edgesIgnoringSafeArea(.all)
            let manager = TrafficRestrictionManager()
            VStack(spacing: 16) {
                // 今日限行信息
                VStack(spacing: 8) {
                    Text(viewModel.dateFormatter.string(from: Date()))
                       .font(.system(size: 16, weight:.regular, design:.default))
                       .foregroundColor(.white)
                    Text("\(manager.weekday(from: Date()))")
                       .font(.system(size: 16, weight:.regular, design:.default))
                       .foregroundColor(.white)
                    Text(viewModel.todayRestriction)
                       .font(.system(size: 36, weight:.bold, design:.default))
                       .foregroundColor(.white)
                }
               .padding(.horizontal, 20)
               .padding(.vertical, 12)
               .background(Color.black.opacity(0.3))
               .cornerRadius(12)
                
                // 一周限行信息列表
                ForEach(viewModel.weekRestrictions) { restriction in
                    HStack {
                        VStack(alignment:.leading, spacing: 4) {
                            if let date = viewModel.dateFormatter.date(from: restriction.date) {
                                Text(viewModel.dateFormatter.string(from: date))
                                   .font(.system(size: 16, weight:.regular, design:.default))
                                   .foregroundColor(.white)
                                Text("\(manager.weekday(from: date))")
                                   .font(.system(size: 16, weight:.regular, design:.default))
                                   .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        Text(restriction.restriction)
                           .font(.system(size: 20, weight:.bold, design:.default))
                           .foregroundColor(.white)
                    }
                   .padding(.horizontal, 20)
                   .padding(.vertical, 12)
                   .background(Color.black.opacity(0.3))
                   .cornerRadius(12)
                }
            }
           .padding(20)
        }
       .onAppear {
            viewModel.fetchData()
        }
    }
}
