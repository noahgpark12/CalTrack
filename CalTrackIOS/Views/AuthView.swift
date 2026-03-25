import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                Button("Sign In") {
                    Task {
                        await session.signIn(email: email, password: password)
                    }
                }
            }
            .navigationTitle("CalTrack")
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(SessionStore())
}
