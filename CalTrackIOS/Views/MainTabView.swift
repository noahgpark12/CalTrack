import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MealCaptureView()
                .tabItem {
                    Label("Capture", systemImage: "camera")
                }

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.xaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
