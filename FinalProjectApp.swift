//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by andres siri on 11/29/24.
//

import SwiftUI
import SwiftData

@main
struct FinalProjectApp: App {
    
        let container: ModelContainer = {
        let schema = Schema([Book.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
        }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Book.self])
    }
}

