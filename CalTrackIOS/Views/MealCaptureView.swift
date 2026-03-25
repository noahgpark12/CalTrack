import PhotosUI
import SwiftUI

struct MealCaptureView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = MealCaptureViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ZStack {
                CalTrackTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        heroCard

                        AppCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Meal details")
                                    .font(.headline)

                                Picker("Meal type", selection: $viewModel.selectedMealType) {
                                    ForEach(MealType.allCases) { mealType in
                                        Text(mealType.title).tag(mealType)
                                    }
                                }
                                .pickerStyle(.segmented)

                                TextField("Add quick notes", text: $viewModel.notes, axis: .vertical)
                                    .padding()
                                    .background(Color.gray.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        AppCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Meal photo")
                                    .font(.headline)

                                PhotosPicker(selection: $pickerItem, matching: .images) {
                                    GradientCTA(label: "Choose Photo", systemImage: "photo.fill")
                                }
                                .onChange(of: pickerItem) { _, newItem in
                                    Task {
                                        viewModel.selectedImageData = try? await newItem?.loadTransferable(type: Data.self)
                                    }
                                }

                                if let imageData = viewModel.selectedImageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 220)
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        }

                        Button {
                            guard let userID = session.userID else { return }
                            Task { await viewModel.saveMeal(userID: userID) }
                        } label: {
                            GradientCTA(label: viewModel.isSaving ? "Saving..." : "Analyze & Save Meal", systemImage: "sparkles")
                        }
                        .disabled(viewModel.isSaving)

                        if let statusMessage = viewModel.statusMessage {
                            Text(statusMessage)
                                .font(.footnote)
                                .foregroundStyle(CalTrackTheme.mutedText)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Meal Scanner")
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(CalTrackTheme.cardGradient)
                .frame(height: 170)

            VStack(alignment: .leading, spacing: 8) {
                Text("AI Nutrition")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Take a photo of every meal and snack. We’ll estimate calories and nutrients instantly.")
                    .foregroundStyle(.white.opacity(0.92))
                    .font(.subheadline)
            }
            .padding(20)
        }
    }
}
