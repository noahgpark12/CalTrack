import Foundation
import UserNotifications

actor NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func scheduleMealReminders() async throws {
        let center = UNUserNotificationCenter.current()
        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        guard granted else { return }

        center.removePendingNotificationRequests(withIdentifiers: ["breakfast-reminder", "lunch-reminder", "dinner-reminder", "snack-reminder"])

        try await schedule(id: "breakfast-reminder", title: "Track breakfast", hour: 8)
        try await schedule(id: "lunch-reminder", title: "Track lunch", hour: 12)
        try await schedule(id: "dinner-reminder", title: "Track dinner", hour: 19)
        try await schedule(id: "snack-reminder", title: "Had a snack?", hour: 16)
    }

    private func schedule(id: String, title: String, hour: Int) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Snap a photo and let AI estimate nutrition in seconds."

        var components = DateComponents()
        components.hour = hour

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
}
