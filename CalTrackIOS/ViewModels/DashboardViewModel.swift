import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var todaySummary: DailyNutritionSummary?
    @Published var todayMeals: [MealEntry] = []
    @Published var isLoading = false

    private let supabase = SupabaseService.shared

    func loadToday(userID: UUID) async {
        isLoading = true
        defer { isLoading = false }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()

        do {
            let meals = try await supabase.fetchMeals(userID: userID, from: start, to: end)
            todayMeals = meals
            todaySummary = buildSummary(from: meals, date: start)
        } catch {
            print("Failed to load dashboard: \(error)")
        }
    }

    private func buildSummary(from meals: [MealEntry], date: Date) -> DailyNutritionSummary {
        let calories = meals.reduce(0) { $0 + $1.nutrition.calories }
        let protein = meals.reduce(0) { $0 + $1.nutrition.proteinGrams }
        let carbs = meals.reduce(0) { $0 + $1.nutrition.carbsGrams }
        let fat = meals.reduce(0) { $0 + $1.nutrition.fatGrams }

        let micronutrientMap = meals
            .flatMap { $0.nutrition.micronutrients }
            .reduce(into: [String: (amount: Double, unit: String, dv: Double)]()) { result, item in
                let current = result[item.name] ?? (0, item.unit, 0)
                result[item.name] = (current.amount + item.amount, item.unit, current.dv + item.dailyValuePercent)
            }

        let progress = micronutrientMap.map {
            DailyNutritionSummary.NutrientProgress(
                nutrientName: $0.key,
                amount: $0.value.amount,
                unit: $0.value.unit,
                dailyValuePercent: min($0.value.dv, 100)
            )
        }
        .sorted { $0.dailyValuePercent > $1.dailyValuePercent }

        return DailyNutritionSummary(
            date: date,
            calories: calories,
            proteinGrams: protein,
            carbsGrams: carbs,
            fatGrams: fat,
            micronutrientProgress: progress
        )
    }
}
