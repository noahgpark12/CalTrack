import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var mealReminders = true
    @State private var hydrationReminders = true
    @State private var weeklyReports = true

    var body: some View {
        NavigationStack {
            ZStack {
                CalTrackTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        AppCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Notifications")
                                    .font(.title3.bold())
                                Text("Stay on track with timely reminders.")
                                    .foregroundStyle(CalTrackTheme.mutedText)

                                Toggle("Meal reminders", isOn: $mealReminders)
                                Toggle("Hydration reminders", isOn: $hydrationReminders)
                                Toggle("Weekly reports", isOn: $weeklyReports)
                            }
                        }

                        AppCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Supabase")
                                    .font(.headline)
                                Label(AppConfig.isConfigured ? "Connected" : "Missing SUPABASE_URL / SUPABASE_ANON_KEY", systemImage: "externaldrive.badge.icloud")
                                    .foregroundStyle(AppConfig.isConfigured ? .green : .orange)
                            }
                        }

                        Button(role: .destructive) {
                            Task { await session.signOut() }
                        } label: {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Profile & Alerts")
        }
    }
}
