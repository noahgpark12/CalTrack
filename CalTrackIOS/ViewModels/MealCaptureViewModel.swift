import Foundation
import SwiftUI

@MainActor
final class MealCaptureViewModel: ObservableObject {
    @Published var selectedImageData: Data?
    @Published var selectedMealType: MealType = .mealDefault
    @Published var notes: String = ""
    @Published var isSaving = false
    @Published var statusMessage: String?

    private let supabase = SupabaseService.shared

    func saveMeal(userID: UUID) async {
        guard let selectedImageData else {
            statusMessage = "Select a photo first."
            return
        }

        isSaving = true
        defer { isSaving = false }

        do {
            let imageURL = try await supabase.uploadMealPhoto(selectedImageData, userID: userID)
            let nutrition = try await supabase.scanMeal(with: imageURL, mealType: selectedMealType, notes: notes)

            let entry = MealEntry(
                id: UUID(),
                userID: userID,
                capturedAt: Date(),
                imageURL: imageURL,
                mealType: selectedMealType,
                foods: [],
                nutrition: nutrition,
                notes: notes.isEmpty ? nil : notes
            )

            try await supabase.insertMealEntry(entry)
            statusMessage = "Meal saved (\(Int(entry.calories)) kcal)."
            notes = ""
            self.selectedImageData = nil
        } catch {
            statusMessage = "Failed to save meal: \(error.localizedDescription)"
        }
    }
}

private extension MealType {
    static var mealDefault: MealType { .breakfast }
}
