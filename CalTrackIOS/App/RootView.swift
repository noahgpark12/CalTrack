import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        Group {
            if session.isLoading {
                ProgressView("Loading CalTrack...")
            } else if session.isAuthenticated {
                MainTabView()
            } else {
                AuthView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SessionStore.preview)
}
