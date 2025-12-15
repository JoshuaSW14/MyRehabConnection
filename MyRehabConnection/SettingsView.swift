//
//  Settings.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI
import CryptoKit

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    var onMenuTapped: () -> Void
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

    private let md5Key = "#RCgray"

    init(onMenuTapped: @escaping () -> Void, initialEmail: String? = nil, initialStoreVideosLocally: Bool = false,
         onClearCache: (() async throws -> Void)? = nil) {
        _email = State(initialValue: initialEmail ?? "")
        _storeVideosLocally = State(initialValue: initialStoreVideosLocally)
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
                print("[SettingsView] onAppear - initial email state: \(email)")
                // Prefill email from local storage if not provided initially and field is empty
                let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    let storedEmail = UserDefaults.standard.string(forKey: "MRC.lastLoginEmail")
                    print("[SettingsView] onAppear - fetched stored email: \(storedEmail ?? "nil")")
                    if let storedEmail, !storedEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        email = storedEmail
                        print("[SettingsView] onAppear - assigned email from UserDefaults: \(email)")
                    } else {
                        print("[SettingsView] onAppear - no valid stored email found")
                    }
                } else {
                    print("[SettingsView] onAppear - email already populated: \(email)")
                }
            }
        }
    }

    // MARK: - Hash helper
    private func md5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    // MARK: - Actions
    private func handleSave() async {
        guard let patientId = authManager.loginResponse?.patientId else {
            alertTitle = "Error"
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }

        // Server manages authentication; no local token handling here
        let newEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        print("[SettingsView] handleSave - attempting to save email: \(newEmail)")
        // Using patientId as required identifier; server does not require local token here

        // Validate new password if provided
        var newPasswordHash: String? = nil
        if !newPassword.isEmpty {
            if newPassword.count < 8 {
                alertTitle = "Error"
                alertMessage = "New password must be at least 8 characters."
                showAlert = true
                return
            }
            guard newPassword == confirmPassword else {
                alertTitle = "Error"
                alertMessage = "New passwords do not match."
                showAlert = true
                return
            }
            newPasswordHash = md5(md5Key + newPassword)
        }

        // Build post parameters
        var postParams: [String: String] = [
            "patient_id": patientId,
            "email": newEmail
        ]
        if let newPassHash = newPasswordHash {
            postParams["new_password"] = newPassHash
        }
        print("[SettingsView] handleSave - postParams: \(postParams)")

        // Prepare URLRequest
        guard let url = URL(string: "https://myrehabconnection.com/portal/app/settings.php") else {
            alertTitle = "Error"
            alertMessage = "Invalid server URL."
            showAlert = true
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyString = postParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                                   .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                alertTitle = "Error"
                alertMessage = "Server returned an unexpected response."
                showAlert = true
                return
            }

            // Parse JSON response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let status = json["status"] as? String, status == "OK" {
                    if let message = json["message"] as? String {
                        alertTitle = "Saved"
                        alertMessage = message
                    } else {
                        alertTitle = "Saved"
                        alertMessage = "Your settings have been updated."
                    }
                    print("[SettingsView] handleSave - server status OK, persisting email to UserDefaults: \(newEmail)")
                    // Keep local email in sync after a successful save
                    UserDefaults.standard.set(newEmail, forKey: "MRC.lastLoginEmail")
                    print("[SettingsView] handleSave - persisted email in UserDefaults: \(UserDefaults.standard.string(forKey: "MRC.lastLoginEmail") ?? "nil")")

                    // If needed, refresh session details via AuthManager after save.

                    showAlert = true
                } else {
                    print("[SettingsView] handleSave - server returned error: \(json["message"] as? String ?? "unknown")")
                    let message = json["message"] as? String ?? "An unknown error occurred."
                    alertTitle = "Error"
                    alertMessage = message
                    showAlert = true
                }
            } else {
                print("[SettingsView] handleSave - failed to parse JSON response")
                alertTitle = "Error"
                alertMessage = "Failed to parse server response."
                showAlert = true
            }
        } catch {
            print("[SettingsView] handleSave - network error: \(error.localizedDescription)")
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

