import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                if let summary = viewModel.todaySummary {
                    Section("Today") {
                        LabeledContent("Calories", value: "\(Int(summary.calories)) kcal")
                        LabeledContent("Protein", value: "\(Int(summary.proteinGrams)) g")
                        LabeledContent("Carbs", value: "\(Int(summary.carbsGrams)) g")
                        LabeledContent("Fat", value: "\(Int(summary.fatGrams)) g")
                    }

                    Section("Daily value progress") {
                        ForEach(summary.micronutrientProgress) { nutrient in
                            VStack(alignment: .leading) {
                                Text(nutrient.nutrientName)
                                ProgressView(value: nutrient.dailyValuePercent / 100)
                                Text("\(Int(nutrient.dailyValuePercent))% DV")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Meals") {
                    ForEach(viewModel.todayMeals) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.mealType.title)
                                .font(.headline)
                            Text("\(Int(meal.nutrition.calories)) kcal")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Nutrition")
            .task {
                guard let userID = session.userID else { return }
                await viewModel.loadToday(userID: userID)
            }
            .refreshable {
                guard let userID = session.userID else { return }
                await viewModel.loadToday(userID: userID)
            }
        }
    }
}
