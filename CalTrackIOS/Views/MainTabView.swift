import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MealCaptureView()
                .tabItem {
                    Label("Meals", systemImage: "camera.fill")
                }

            DashboardView()
                .tabItem {
                    Label("Trends", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(CalTrackTheme.primary)
    }
}
