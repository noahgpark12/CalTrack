import Foundation

enum AppConfig {
    static let supabaseURL = URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? "")
    static let supabaseAnonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
    static let scanFunctionName = "scan-meal"

    static var isConfigured: Bool {
        supabaseURL != nil && !supabaseAnonKey.isEmpty
    }
}
