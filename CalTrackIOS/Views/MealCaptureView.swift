import PhotosUI
import SwiftUI

struct MealCaptureView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = MealCaptureViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal details") {
                    Picker("Meal type", selection: $viewModel.selectedMealType) {
                        ForEach(MealType.allCases) { mealType in
                            Text(mealType.title).tag(mealType)
                        }
                    }

                    TextField("Notes (optional)", text: $viewModel.notes, axis: .vertical)
                }

                Section("Photo") {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("Choose photo", systemImage: "photo")
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
                            .scaledToFit()
                            .frame(maxHeight: 220)
                    }
                }

                Section {
                    Button(viewModel.isSaving ? "Saving..." : "Analyze & Save") {
                        guard let userID = session.userID else { return }
                        Task {
                            await viewModel.saveMeal(userID: userID)
                        }
                    }
                    .disabled(viewModel.isSaving)

                    if let statusMessage = viewModel.statusMessage {
                        Text(statusMessage)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Capture meal")
        }
    }
}
