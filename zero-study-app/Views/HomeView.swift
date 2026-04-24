import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: Store
    @State private var isStudying = false
    @State private var timerSeconds = 0
    @State private var timer: Timer?
    @State private var showConfirmEnd = false
    @State private var showGoalReached = false
    @State private var isAddTaskModalOpen = false
    
    var todayStats: DayStats {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return store.state.history.first(where: { $0.date == today }) ?? DayStats(date: today, durationSeconds: 0)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // Header
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.duoOrange)
                            .font(.system(size: 24))
                        Text("\(store.state.streak)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.duoOrange)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .duoCardStyle()
                    
                    Spacer()
                }
                
                // Timer Section
                VStack(spacing: 16) {
                    Text("今日学习：\(todayStats.durationSeconds / 60) / \(store.state.dailyGoalMinutes) 分钟")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.duoGrayDark)
                    
                    Text(formatTime(isStudying ? timerSeconds : todayStats.durationSeconds))
                        .font(.system(size: 64, design: .monospaced))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.vertical, 16)
                    
                    Button(action: {
                        if isStudying {
                            showConfirmEnd = true
                        } else {
                            startStudy()
                        }
                    }) {
                        HStack {
                            Image(systemName: isStudying ? "square.fill" : "play.fill")
                            Text(isStudying ? "结束学习" : "开始学习")
                        }
                    }
                    .duoButtonStyle(variant: isStudying ? .red : .green, fullWidth: true)
                }
                .padding(24)
                .duoCardStyle()
                
                // Tasks Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("今日核心 (\(store.state.tasks.count)/3)")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        if store.state.tasks.count < 3 {
                            Button(action: { isAddTaskModalOpen = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                    Text("添加")
                                }
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.duoBlue)
                            }
                        }
                    }
                    
                    if store.state.tasks.isEmpty {
                        Text("专注核心，建议添加 3 条以内任务。")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.duoGrayDark)
                            .frame(maxWidth: .infinity)
                            .padding(32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                    .foregroundColor(.duoGrayDark.opacity(0.5))
                            )
                    } else {
                        VStack(spacing: 12) {
                            ForEach(store.state.tasks) { task in
                                TaskCard(task: task)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(24)
            
            if showConfirmEnd {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 24) {
                            Text("结束本次学习？")
                                .font(.system(size: 24, weight: .bold))
                            Text("当前累计：\(formatTime(timerSeconds))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.duoGrayDark)
                            
                            VStack(spacing: 12) {
                                Button("确认完成并保存") {
                                    endStudy(confirm: true)
                                }
                                .duoButtonStyle(variant: .green, fullWidth: true)
                                
                                Button("还没学完，继续") {
                                    endStudy(confirm: false)
                                }
                                .duoButtonStyle(variant: .gray, fullWidth: true)
                            }
                        }
                        .padding(32)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(24)
                        .padding(24)
                        .duoCardStyle()
                    )
                    .zIndex(1)
            }
            
            if showGoalReached {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 16) {
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.white)
                            Text("目标达成！")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            Text("坚持就是胜利 🏆")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(40)
                        .background(Color.duoGreen)
                        .cornerRadius(32)
                        .shadow(radius: 20)
                    )
                    .zIndex(2)
            }
        }
        .sheet(isPresented: $isAddTaskModalOpen) {
            AddTaskSheet(isOpen: $isAddTaskModalOpen)
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let hrs = totalSeconds / 3600
        let mins = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    func startStudy() {
        isStudying = true
        timerSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timerSeconds += 1
        }
    }
    
    func endStudy(confirm: Bool) {
        showConfirmEnd = false
        if !confirm { return }
        
        timer?.invalidate()
        timer = nil
        isStudying = false
        
        if timerSeconds < 1 { return }
        
        let wasBelowGoal = todayStats.durationSeconds < store.state.dailyGoalMinutes * 60
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        
        var newHistory = store.state.history
        if let index = newHistory.firstIndex(where: { $0.date == todayDate }) {
            newHistory[index].durationSeconds += timerSeconds
        } else {
            newHistory.append(DayStats(date: todayDate, durationSeconds: timerSeconds))
        }
        
        var newStreak = store.state.streak
        let alreadyActiveToday = store.state.lastActiveDate == todayDate
        if !alreadyActiveToday && timerSeconds >= 60 {
            newStreak += 1
        }
        
        store.state.history = newHistory
        store.state.streak = newStreak
        store.state.lastActiveDate = todayDate
        
        let isNowAboveGoal = todayStats.durationSeconds >= store.state.dailyGoalMinutes * 60
        if wasBelowGoal && isNowAboveGoal {
            withAnimation {
                showGoalReached = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showGoalReached = false
                }
            }
        }
    }
}

struct TaskCard: View {
    @EnvironmentObject var store: Store
    var task: FocusTask
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                if let index = store.state.tasks.firstIndex(where: { $0.id == task.id }) {
                    store.state.tasks[index].completed.toggle()
                }
            }) {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.completed ? .duoGreen : .duoGray)
            }
            
            Text(task.text)
                .font(.system(size: 18, weight: .bold))
                .strikethrough(task.completed)
                .foregroundColor(task.completed ? .duoGrayDark : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                store.state.tasks.removeAll(where: { $0.id == task.id })
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(.duoGrayDark)
            }
        }
        .padding(16)
        .background(task.completed ? Color.duoGray.opacity(0.2) : (Color(UIColor.systemBackground)))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(task.completed ? Color.duoGray : Color.cardBorderDark, lineWidth: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(task.completed ? Color.duoGray : Color.cardBorderDark, lineWidth: 4)
                .padding(.top, 2)
                .mask(VStack { Spacer(); Rectangle().frame(height: 4) })
        )
        .opacity(task.completed ? 0.6 : 1.0)
    }
}

struct AddTaskSheet: View {
    @EnvironmentObject var store: Store
    @Binding var isOpen: Bool
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("输入任务内容...", text: $text)
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.top, 16)
                
                Button("确认添加") {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        store.state.tasks.append(FocusTask(text: text, completed: false))
                        isOpen = false
                    }
                }
                .duoButtonStyle(variant: .blue, fullWidth: true)
                
                Spacer()
            }
            .padding()
            .navigationTitle("新焦点任务")
            .navigationBarItems(trailing: Button(action: { isOpen = false }) {
                Image(systemName: "xmark")
                    .foregroundColor(.duoGrayDark)
            })
        }
        .presentationDetents([.height(250)])
    }
}
