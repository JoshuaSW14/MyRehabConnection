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
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .tint(.mrcRed)
        }
    }
}
