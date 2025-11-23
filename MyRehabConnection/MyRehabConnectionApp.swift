//
//  MyRehabConnectionApp.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI
import CoreData

@main
struct MyRehabConnectionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
