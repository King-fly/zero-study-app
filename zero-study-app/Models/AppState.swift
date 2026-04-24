import Foundation
import SwiftUI

struct FocusTask: Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String
    var completed: Bool
}

struct DayStats: Codable {
    var date: String // YYYY-MM-DD
    var durationSeconds: Int
}

struct AppStateData: Codable {
    var tasks: [FocusTask]
    var dailyGoalMinutes: Int
    var history: [DayStats]
    var streak: Int
    var lastActiveDate: String?
}

class Store: ObservableObject {
    @Published var state: AppStateData {
        didSet {
            saveState()
        }
    }
    
    private let storageKey = "minimal_study_app_state_v2"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "minimal_study_app_state_v2"),
           let decoded = try? JSONDecoder().decode(AppStateData.self, from: data) {
            self.state = decoded
        } else {
            // Initial seed data
            var history: [DayStats] = []
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            for i in 1...7 {
                if let d = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                    history.append(DayStats(
                        date: formatter.string(from: d),
                        durationSeconds: Int.random(in: 1200...4800)
                    ))
                }
            }
            
            self.state = AppStateData(
                tasks: [
                    FocusTask(text: "完成数学课后题", completed: false),
                    FocusTask(text: "阅读 10 页英语原著", completed: true)
                ],
                dailyGoalMinutes: 60,
                history: history.reversed(),
                streak: 3,
                lastActiveDate: formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
            )
        }
        
        checkStreak()
    }
    
    func saveState() {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func checkStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if let lastDateStr = state.lastActiveDate, lastDateStr != today {
            if let lastDate = formatter.date(from: lastDateStr),
               let todayDate = formatter.date(from: today) {
                let components = Calendar.current.dateComponents([.day], from: lastDate, to: todayDate)
                if let days = components.day, days > 1 {
                    state.streak = 0
                }
            }
        }
    }
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        // Reset to empty state (no seed)
        self.state = AppStateData(
            tasks: [],
            dailyGoalMinutes: 60,
            history: [],
            streak: 0,
            lastActiveDate: nil
        )
    }
}
