//
//  RootView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                NavigationStack {
                    MainAppView()
                }
            } else {
                LoginView()
            }
        }
    }
}
