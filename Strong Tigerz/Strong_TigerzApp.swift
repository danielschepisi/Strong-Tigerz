//
//  Strong_TigerzApp.swift
//  Strong Tigerz
//
//  Created by Daniel Schepisi on 16/5/2026.
//

import SwiftData
import SwiftUI

@main
struct Strong_TigerzApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Meal.self)
    }
}
