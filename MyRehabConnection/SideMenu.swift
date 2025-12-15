//
//  SideMenu.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI

struct SideMenu: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.openURL) private var openURL
    
    @Binding var selectedTab: Int
    var onClose: () -> Void
    
    private var clinic: Clinic? {
        authManager.loginResponse?.clinic
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("My Rehab Connection")
                .font(.title2)
                .bold()
                .padding(.top, 40)
            
            if let clinic {
                Text(clinic.name)
                    .font(.headline)
                Text("\(clinic.city), \(clinic.provinceState)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider().padding(.vertical, 8)
            
            // Menu items
            Group {
                menuButton(title: "My Exercises", systemImage: "list.bullet") {
                    selectedTab = 0
                }
                
                menuButton(title: "Clinic Info", systemImage: "info.circle") {
                    selectedTab = 2
                }
                
                menuButton(title: "Make Appointment", systemImage: "calendar.badge.plus") {
                    if let urlString = clinic?.appointment,
                       let url = URL(string: urlString) {
                        openURL(url)
                    }
                }
                
                menuButton(title: "Call Us", systemImage: "phone") {
                    if let phone = clinic?.phone,
                       let url = URL(string: "tel://\(phone)") {
                        openURL(url)
                    }
                }
                
                menuButton(title: "Email Us", systemImage: "envelope") {
                    if let email = clinic?.email,
                       let url = URL(string: "mailto:\(email)") {
                        openURL(url)
                    }
                }
                
                menuButton(title: "Our Website", systemImage: "globe") {
                    if let website = clinic?.website,
                       let url = URL(string: website) {
                        openURL(url)
                    }
                }
                
                menuButton(title: "Map/Directions", systemImage: "map") {
                    if let clinic {
                        let address = "\(clinic.address1), \(clinic.city), \(clinic.provinceState) \(clinic.postalZip)"
                        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "http://maps.apple.com/?daddr=\(encoded)") {
                            openURL(url)
                        }
                    }
                }
                
                menuButton(title: "Settings", systemImage: "gearshape") {
                    selectedTab = 1
                }
                
                menuButton(title: "Privacy Policy", systemImage: "doc.text") {
                    selectedTab = 3
                }
            }
            
            Spacer()
            
            // Logout at bottom
            Button(role: .destructive) {
                onClose()
                authManager.logout()
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .padding(.vertical, 8)
            }
            
            Spacer(minLength: 16)
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .shadow(radius: 8)
    }
    
    @ViewBuilder
    private func menuButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
            onClose()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                Text(title)
                Spacer()
            }
            .padding(.vertical, 6)
        }
    }
}

