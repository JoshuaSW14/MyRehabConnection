//
//  MainAppView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isMenuOpen = false
    @State private var selectedTab = 0    // 0 = Videos, 1 = Settings
    
    var body: some View {
        ZStack(alignment: .leading) {
            TabView(selection: $selectedTab) {
                VideoListView(onMenuTapped: toggleMenu)
                    .tag(0)
                    .tabItem {
                        Label("Videos", systemImage: "play.rectangle")
                    }
                
                SettingsView()
                    .tag(1)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isMenuOpen = false } }
                
                SideMenu(
                    selectedTab: $selectedTab,
                    onClose: { withAnimation { isMenuOpen = false } }
                )
                .frame(width: 260)
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
    }
    
    private func toggleMenu() {
        withAnimation {
            isMenuOpen.toggle()
        }
    }
}

