import SwiftUI

enum CalTrackTheme {
    static let background = Color(red: 0.95, green: 0.96, blue: 0.95)
    static let surface = Color.white
    static let primary = Color(red: 0.09, green: 0.58, blue: 0.27)
    static let accent = Color(red: 0.45, green: 0.86, blue: 0.43)
    static let deepText = Color(red: 0.12, green: 0.17, blue: 0.15)
    static let mutedText = Color(red: 0.42, green: 0.47, blue: 0.45)

    static let cardGradient = LinearGradient(
        colors: [Color(red: 0.13, green: 0.61, blue: 0.30), Color(red: 0.47, green: 0.88, blue: 0.41)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CalTrackTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct GradientCTA: View {
    let label: String
    let systemImage: String

    var body: some View {
        Label(label, systemImage: systemImage)
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(CalTrackTheme.cardGradient)
            .clipShape(Capsule())
    }
}
