import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                CalTrackTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        if let summary = viewModel.todaySummary {
                            caloriesRing(summary: summary)
                            macrosCard(summary: summary)
                            micronutrientCard(summary: summary)
                        }

                        timelineCard
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Vitality Trends")
            .task { await reload() }
            .refreshable { await reload() }
        }
    }

    private func caloriesRing(summary: DailyNutritionSummary) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Daily calories")
                    .font(.headline)

                HStack {
                    Gauge(value: min(summary.calories / 2200, 1.0)) {
                        Text("")
                    } currentValueLabel: {
                        Text("\(Int(summary.calories))")
                            .font(.title.bold())
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(CalTrackTheme.primary)
                    .scaleEffect(1.7)
                    .frame(width: 130, height: 130)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your energy is blooming today.")
                            .font(.headline)
                        Text("Target: 2,200 kcal")
                            .foregroundStyle(CalTrackTheme.mutedText)
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                }
            }
        }
    }

    private func macrosCard(summary: DailyNutritionSummary) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Macronutrients")
                    .font(.headline)

                macroRow(name: "Protein", value: summary.proteinGrams, tint: .green)
                macroRow(name: "Carbs", value: summary.carbsGrams, tint: .blue)
                macroRow(name: "Fat", value: summary.fatGrams, tint: .orange)
            }
        }
    }

    private func micronutrientCard(summary: DailyNutritionSummary) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Daily Value Progress")
                    .font(.headline)

                ForEach(summary.micronutrientProgress.prefix(5)) { nutrient in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(nutrient.nutrientName)
                            Spacer()
                            Text("\(Int(nutrient.dailyValuePercent))%")
                                .foregroundStyle(CalTrackTheme.mutedText)
                        }
                        ProgressView(value: nutrient.dailyValuePercent / 100)
                            .tint(CalTrackTheme.primary)
                    }
                }
            }
        }
    }

    private var timelineCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Today’s Timeline")
                    .font(.headline)

                if viewModel.todayMeals.isEmpty {
                    Text("No meals logged yet — tap Meals to add your next meal.")
                        .foregroundStyle(CalTrackTheme.mutedText)
                } else {
                    ForEach(viewModel.todayMeals) { meal in
                        HStack {
                            Circle()
                                .fill(CalTrackTheme.primary)
                                .frame(width: 8, height: 8)
                            Text(meal.mealType.title)
                            Spacer()
                            Text("\(Int(meal.nutrition.calories)) kcal")
                                .foregroundStyle(CalTrackTheme.mutedText)
                        }
                    }
                }
            }
        }
    }

    private func macroRow(name: String, value: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                Spacer()
                Text("\(Int(value)) g")
                    .foregroundStyle(CalTrackTheme.mutedText)
            }
            ProgressView(value: min(value / 120, 1.0))
                .tint(tint)
        }
    }

    private func reload() async {
        guard let userID = session.userID else { return }
        await viewModel.loadToday(userID: userID)
    }
}
