//
//  ContentView.swift
//  Strong Tigerz
//
//  Created by Daniel Schepisi on 16/5/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Meal.dateAdded, order: .reverse) private var meals: [Meal]
    @State private var selectedMeal: Meal?
    
    var body: some View {
        NavigationStack {
            List(meals) { meal in
                NavigationLink {
                    MealView(meal: meal)
                } label: {
                    HStack(spacing: 15) {
                        //Display the photo if it exists, otherwise a placeholder
                        if let data = meal.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image(systemName: "fork.knife")
                                .frame(width: 50, height: 50)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        VStack(alignment: .leading) {
                            Text(meal.name)
                                .font(.headline)
                            Text("more details to come")
                            Text("even more")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Strong Tigerz")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MealView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Meal.previewContainer)
}
