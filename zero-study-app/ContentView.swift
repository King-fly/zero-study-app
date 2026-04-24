import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                StatsView()
                    .tag(1)
                
                SettingsView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom Tab Bar
            HStack {
                TabBarButton(iconName: "play.fill", title: "学习", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabBarButton(iconName: "chart.bar.fill", title: "统计", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabBarButton(iconName: "gearshape.fill", title: "设置", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.vertical, 12)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
            .background(Color(UIColor.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(UIColor.separator)),
                alignment: .top
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarButton: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(isSelected ? .duoBlue : .duoGrayDark)
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
    }
}
