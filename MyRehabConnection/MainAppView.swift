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
    @State private var showClinicInfo = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                switch selectedTab {
                case 0:
                    VideoListView(onMenuTapped: toggleMenu)
                case 1:
                    SettingsView(onMenuTapped: toggleMenu)
                case 2:
                    ClinicInfoView(onMenuTapped: toggleMenu)
                case 3:
                    PrivacyPolicyView(onMenuTapped: toggleMenu)
                default:
                    VideoListView(onMenuTapped: toggleMenu)
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
