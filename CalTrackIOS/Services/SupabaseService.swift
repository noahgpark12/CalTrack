import Foundation

/// Wrapper around Supabase Auth, Storage, PostgREST and Edge Functions.
///
/// Replace placeholder implementations with `Supabase` framework calls:
/// https://github.com/supabase-community/supabase-swift
actor SupabaseService {
    static let shared = SupabaseService()

    private init() {}

    struct UserSession {
        let userID: String
        let accessToken: String
    }

    func currentSession() async throws -> UserSession? {
        // TODO: Wire to supabase.auth.session
        nil
    }

    func signIn(email: String, password: String) async throws -> UserSession {
        // TODO: Wire to supabase.auth.signIn
        UserSession(userID: UUID().uuidString, accessToken: "mock-token")
    }

    func signOut() async throws {
        // TODO: Wire to supabase.auth.signOut
    }

    func uploadMealPhoto(_ imageData: Data, userID: UUID) async throws -> URL {
        // TODO: Wire to Supabase Storage bucket `meal-photos`
        URL(string: "https://example.com/mock-photo.jpg")!
    }

    func scanMeal(with imageURL: URL, mealType: MealType, notes: String?) async throws -> NutritionSnapshot {
        let payload: [String: Any] = [
            "image_url": imageURL.absoluteString,
            "meal_type": mealType.rawValue,
            "notes": notes ?? ""
        ]

        // TODO: Replace with `supabase.functions.invoke`
        print("Invoke edge function \(AppConfig.scanFunctionName) with payload: \(payload)")

        return NutritionSnapshot(
            calories: 530,
            proteinGrams: 32,
            carbsGrams: 48,
            fatGrams: 21,
            fiberGrams: 8,
            sodiumMilligrams: 620,
            micronutrients: [
                Micronutrient(name: "Vitamin C", amount: 35, unit: "mg", dailyValuePercent: 39),
                Micronutrient(name: "Iron", amount: 4.5, unit: "mg", dailyValuePercent: 25)
            ]
        )
    }

    func insertMealEntry(_ entry: MealEntry) async throws {
        // TODO: Wire to PostgREST insert on `meal_entries`
        print("Persist meal entry: \(entry.id)")
    }

    func fetchMeals(userID: UUID, from startDate: Date, to endDate: Date) async throws -> [MealEntry] {
        // TODO: Wire to PostgREST range query
        []
    }
}
