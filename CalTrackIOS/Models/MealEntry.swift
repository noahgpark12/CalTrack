import Foundation

struct MealEntry: Identifiable, Codable {
    let id: UUID
    let userID: UUID
    let capturedAt: Date
    let imageURL: URL?
    let mealType: MealType
    let foods: [FoodItem]
    let nutrition: NutritionSnapshot
    let notes: String?

    var calories: Double { nutrition.calories }
}

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case snack

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct FoodItem: Codable, Hashable {
    let name: String
    let estimatedServing: String
}

struct NutritionSnapshot: Codable, Hashable {
    let calories: Double
    let proteinGrams: Double
    let carbsGrams: Double
    let fatGrams: Double
    let fiberGrams: Double
    let sodiumMilligrams: Double
    let micronutrients: [Micronutrient]
}

struct Micronutrient: Codable, Hashable, Identifiable {
    var id: String { name }
    let name: String
    let amount: Double
    let unit: String
    let dailyValuePercent: Double
}
