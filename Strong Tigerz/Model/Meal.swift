//
//  Meal.swift
//  Strong Tigerz
//
//  Created by Daniel Schepisi on 16/5/2026.
//

import Foundation
import SwiftData
import UIKit // Needed to convert SF Symbols into UIImage data

@Model
class Meal: Identifiable {
    var name: String
    var dateAdded: Date
    @Attribute(.externalStorage) var photoData: Data?
    
    init(name: String, dateAdded: Date = .now, photoData: Data? = nil) {
        self.name = name
        self.dateAdded = dateAdded
        self.photoData = photoData
    }
    
    // --- ADD THIS FOR PREVIEWS ---
    @MainActor
    static var previewContainer: ModelContainer = {
        do {
            // 1. Create an in-memory container so it doesn't save to disk
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Meal.self, configurations: config)
            
            // Helper closure to turn system icons into Data
            let getSystemImageData = { (systemName: String) -> Data? in
                let configuration = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
                return UIImage(systemName: systemName, withConfiguration: configuration)?
                    .pngData()
            }
            
            // 2. Insert sample data
            let sampleMeals = [
                Meal(name: "Avocado Toast", photoData: getSystemImageData("snowflake")),
                Meal(name: "Chicken & Rice", photoData: getSystemImageData("carrot.fill")),
                Meal(name: "Protein Shake", photoData: getSystemImageData("fork.knife")),
                Meal(name: "Pizza Slice", photoData: getSystemImageData("cup.and.saucer.fill")),
                Meal(name: "Yully")
            ]
            
            for meal in sampleMeals {
                container.mainContext.insert(meal)
            }
            
            return container
        } catch {
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    } ()
}

