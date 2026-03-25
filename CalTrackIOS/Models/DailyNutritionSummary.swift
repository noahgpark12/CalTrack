import Foundation

struct DailyNutritionSummary: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let proteinGrams: Double
    let carbsGrams: Double
    let fatGrams: Double
    let micronutrientProgress: [NutrientProgress]

    struct NutrientProgress: Identifiable {
        var id: String { nutrientName }
        let nutrientName: String
        let amount: Double
        let unit: String
        let dailyValuePercent: Double
    }
}
