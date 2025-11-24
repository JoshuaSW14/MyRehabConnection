//
//  Settings.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Log Out", role: .destructive) {
                        authManager.logout()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
