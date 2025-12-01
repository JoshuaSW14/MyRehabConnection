//
//  Settings.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    var onMenuTapped: () -> Void
    // Inputs / Outputs
    var onSave: ((_ email: String, _ currentPassword: String?, _ newPassword: String?, _ storeVideosLocally: Bool) async throws -> Void)?
    var onClearCache: (() async throws -> Void)?

    // Form State
    @State private var email: String
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var storeVideosLocally: Bool

    // Alerts
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    init(onMenuTapped: @escaping () -> Void, initialEmail: String? = nil, initialStoreVideosLocally: Bool = false,
         onSave: ((_ email: String, _ currentPassword: String?, _ newPassword: String?, _ storeVideosLocally: Bool) async throws -> Void)? = nil,
         onClearCache: (() async throws -> Void)? = nil) {
        _email = State(initialValue: initialEmail ?? "")
        _storeVideosLocally = State(initialValue: initialStoreVideosLocally)
        self.onSave = onSave
        self.onClearCache = onClearCache
        self.onMenuTapped = onMenuTapped
    }

    private var canSubmit: Bool {
        // email must be non-empty
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        // If any password field is non-empty, require them all and confirm match
        let anyPassword = !currentPassword.isEmpty || !newPassword.isEmpty || !confirmPassword.isEmpty
        if anyPassword {
            guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else { return false }
            guard newPassword == confirmPassword else { return false }
        }
        return true
    }

    var body: some View {
        VStack(spacing: 0) {
            MRCHeader(title: "My Rehab Connection", onMenuTapped: onMenuTapped)
            
            VStack(spacing: 4) {
                Text("Settings")
                    .font(.title2)
                    .bold()
                    .padding(.top, 8)
                Divider()
            }
            .background(Color.white)
            
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }

                Section("Security") {
                    SecureField("Current Password", text: $currentPassword)
                        .textContentType(.password)
                    SecureField("New Password", text: $newPassword)
                        .textContentType(.newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                    if !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword != confirmPassword {
                        Text("New passwords do not match.")
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Toggle("Store exercise videos locally", isOn: $storeVideosLocally)
                } header: {
                    Text("Storage")
                } footer: {
                    Text("When enabled, downloaded exercise videos are saved on device for offline access. This may increase storage usage.")
                }

                Section("Actions") {
                    Button {
                        Task { await handleSave() }
                    } label: {
                        Text("Save Settings")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(!canSubmit)

                    Button(role: .destructive) {
                        Task { await handleClearCache() }
                    } label: {
                        Text("Clear App Cache")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(alertMessage)
            })
            .onAppear {
                // If no initial email provided, leave as-is. Wire to AuthManager here if/when an email source is available.
            }
        }
    }

    // MARK: - Actions
    private func handleSave() async {
        do {
            try await onSave?(email, currentPassword.isEmpty ? nil : currentPassword, newPassword.isEmpty ? nil : newPassword, storeVideosLocally)
            alertTitle = "Saved"
            alertMessage = "Your settings have been updated."
            showAlert = true
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func handleClearCache() async {
        do {
            try await onClearCache?()
            alertTitle = "Cache Cleared"
            alertMessage = "The app's cache has been cleared."
            showAlert = true
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}

