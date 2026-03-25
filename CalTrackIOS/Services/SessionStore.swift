import Foundation
import Observation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var isAuthenticated = false
    @Published private(set) var userID: UUID?

    private let supabase = SupabaseService.shared

    func bootstrap() async {
        defer { isLoading = false }

        do {
            if let session = try await supabase.currentSession() {
                isAuthenticated = true
                userID = UUID(uuidString: session.userID)
                try await NotificationManager.shared.scheduleMealReminders()
            }
        } catch {
            print("Failed to bootstrap session: \(error)")
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let session = try await supabase.signIn(email: email, password: password)
            isAuthenticated = true
            userID = UUID(uuidString: session.userID)
            try await NotificationManager.shared.scheduleMealReminders()
        } catch {
            print("Sign in failed: \(error)")
        }
    }

    func signOut() async {
        do {
            try await supabase.signOut()
            isAuthenticated = false
            userID = nil
        } catch {
            print("Sign out failed: \(error)")
        }
    }

    static let preview: SessionStore = {
        let store = SessionStore()
        store.isLoading = false
        store.isAuthenticated = true
        store.userID = UUID()
        return store
    }()
}
