import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                CalTrackTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerCard

                        AppCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Welcome back")
                                    .font(.title2.bold())
                                Text("Snap meals, track calories, and hit your nutrition goals.")
                                    .foregroundStyle(CalTrackTheme.mutedText)

                                TextField("Email", text: $email)
                                    .textInputAutocapitalization(.never)
                                    .padding()
                                    .background(Color.gray.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                Button {
                                    Task { await session.signIn(email: email, password: password) }
                                } label: {
                                    GradientCTA(label: "Log in", systemImage: "arrow.right")
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var headerCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(CalTrackTheme.cardGradient)
                .frame(height: 210)

            VStack(alignment: .leading, spacing: 8) {
                Text("CalTrack")
                    .font(.title.bold())
                Text("Nourish your vitality, one snap at a time.")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.92))
            }
            .foregroundStyle(.white)
            .padding(20)
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(SessionStore())
}
