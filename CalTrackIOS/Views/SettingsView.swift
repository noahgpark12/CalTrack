import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        NavigationStack {
            List {
                Section("Supabase") {
                    Label(AppConfig.isConfigured ? "Configured" : "Missing SUPABASE_URL / SUPABASE_ANON_KEY", systemImage: "externaldrive.badge.icloud")
                        .foregroundStyle(AppConfig.isConfigured ? .green : .orange)
                }

                Section {
                    Button("Sign Out", role: .destructive) {
                        Task {
                            await session.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
