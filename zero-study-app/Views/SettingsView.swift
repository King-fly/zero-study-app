import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @State private var isResetConfirmOpen = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("偏好设置")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 24) {
                Text("每日时长目标 (\(store.state.dailyGoalMinutes) 分钟)")
                    .font(.system(size: 18, weight: .bold))
                
                HStack(spacing: 16) {
                    Slider(value: Binding(
                        get: { Double(store.state.dailyGoalMinutes) },
                        set: { store.state.dailyGoalMinutes = Int($0) }
                    ), in: 15...300, step: 15)
                    .accentColor(.duoGreen)
                    
                    Text("\(store.state.dailyGoalMinutes)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.duoGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.duoGreen.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.duoGreen, lineWidth: 2)
                        )
                }
                
                HStack {
                    Text("15m").font(.system(size: 12, weight: .bold)).foregroundColor(.duoGrayDark)
                    Spacer()
                    Text("300m").font(.system(size: 12, weight: .bold)).foregroundColor(.duoGrayDark)
                }
            }
            .padding(24)
            .duoCardStyle()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("危险区域")
                    .font(.system(size: 18, weight: .bold))
                
                Text("重置将移除所有任务、打卡天数和历史记录。数据无法恢复。")
                    .font(.system(size: 14))
                    .foregroundColor(.duoGrayDark)
                    .padding(.bottom, 16)
                
                Button(action: {
                    isResetConfirmOpen = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("重置所有本地数据")
                    }
                }
                .duoButtonStyle(variant: .red, fullWidth: true)
            }
            .padding(24)
            .duoCardStyle()
            
            Spacer()
        }
        .padding(24)
        .sheet(isPresented: $isResetConfirmOpen) {
            ResetConfirmSheet(isOpen: $isResetConfirmOpen)
        }
    }
}

struct ResetConfirmSheet: View {
    @EnvironmentObject var store: Store
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("确定重置数据？")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.duoRed)
            
            Text("此操作将永久清空本地的所有历史记录和连续打卡天数。")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.duoGrayDark)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button("是的，全部清空") {
                    store.clearData()
                    isOpen = false
                }
                .duoButtonStyle(variant: .red, fullWidth: true)
                
                Button("手滑了，取消") {
                    isOpen = false
                }
                .duoButtonStyle(variant: .gray, fullWidth: true)
            }
        }
        .padding(32)
        .presentationDetents([.height(350)])
    }
}
