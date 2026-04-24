import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var store: Store
    
    var enrichedHistory: [ChartData] {
        var days: [ChartData] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "E"
        
        for i in (0..<7).reversed() {
            if let d = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                let dateStr = formatter.string(from: d)
                let dayName = displayFormatter.string(from: d)
                let found = store.state.history.first(where: { $0.date == dateStr })
                days.append(ChartData(dayName: dayName, minutes: (found?.durationSeconds ?? 0) / 60))
            }
        }
        return days
    }
    
    var totalMinutes: Int {
        store.state.history.reduce(0) { $0 + $1.durationSeconds } / 60
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("学习资产")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("近 7 日时长 (分钟)")
                    .font(.system(size: 18, weight: .bold))
                Text("累计学习：\(totalMinutes) 分钟")
                    .font(.system(size: 14))
                    .foregroundColor(.duoGrayDark)
                    .padding(.bottom, 8)
                
                Chart(enrichedHistory) { item in
                    BarMark(
                        x: .value("Day", item.dayName),
                        y: .value("Minutes", item.minutes)
                    )
                    .foregroundStyle(item.minutes > 0 ? Color.duoGreen : Color.duoGray)
                    .cornerRadius(8)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel {
                            if let name = value.as(String.self) {
                                Text(name)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.duoGrayDark)
                            }
                        }
                    }
                }
                .chartYAxis(.hidden)
            }
            .padding(24)
            .duoCardStyle()
            
            HStack(spacing: 16) {
                VStack {
                    Text("\(store.state.streak)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.duoBlue)
                    Text("连续打卡")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.duoGrayDark)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.duoBlue, lineWidth: 2)
                )
                
                VStack {
                    Text("\(store.state.history.count)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.duoOrange)
                    Text("累计天数")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.duoGrayDark)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.duoOrange, lineWidth: 2)
                )
            }
            
            Spacer()
        }
        .padding(24)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let dayName: String
    let minutes: Int
}
