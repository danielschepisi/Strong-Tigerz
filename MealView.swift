//
//  MealView.swift
//  Strong Tigerz
//
//  Created by Daniel Schepisi on 16/5/2026.
//

import SwiftUI
import PhotosUI
import SwiftData
import UIKit

struct MealView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var meal: Meal?
    @State private var editMode = false
    
    @State private var name = ""
    @State private var uiImage: UIImage?
    @State private var photoSelection: PhotosPickerItem?
    @State private var showCamera = false
    
    //testing that we have new shit
    
    var body: some View {
        Form {
            TextField("Meal Name", text: $name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Section() {
                if let uiImage {
                    HStack{
                        Spacer()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                
                HStack {
                    // Option 1: Photo Library (Native SwiftUI)
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Label("Gallery", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                    
                    // Option 2: Camera (Using our helper)
                    Button {
                        showCamera = true
                    } label: {
                        Label("Camera", systemImage: "camera")
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .navigationTitle(editMode ? "Edit Meal" : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(editMode ? "Save" : "Edit") {
                    editMode ? saveMeal() : editMode.toggle()
                }
                .disabled(name.isEmpty) // Don't allow saving without a name
            }
        }
        .onAppear {
            if let meal {
                name = meal.name
                if let data = meal.photoData {
                    uiImage = UIImage(data: data)
                }
            } else {
                editMode = true
            }
        }
        // Listens for Photo Library pick
        .onChange(of: photoSelection) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    uiImage = image
                }
            }
        }
        // Triggers Camera Sheet
        .sheet(isPresented: $showCamera) {
            CameraPicker(selectedImage: $uiImage)
        }
    }
    
    private func saveMeal() {
        // Convert UIImage to Data before saving
        let data = uiImage?.jpegData(compressionQuality: 0.8)
        
        let newMeal = Meal(name: name, photoData: data)
        modelContext.insert(newMeal)
        dismiss()
    }
}

#Preview {
    let context = Meal.previewContainer.mainContext
    let fetchedMeals = try? context.fetch(FetchDescriptor<Meal>())
    let firstMeal = fetchedMeals?.first ?? Meal(name: "Fallback Meal")
    return MealView(meal: firstMeal)
        .modelContainer(Meal.previewContainer)
}
