//
//  AuthManager.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation
import Combine

final class AuthManager: ObservableObject {
    @Published var loginResponse: LoginResponse? {
        didSet {
            persistUser()
        }
    }
    
    static let shared = AuthManager()
    
    private let userKey = "mrc_login_response"
    
    private init() {
        loadUser()
    }
    
    func setUser(_ response: LoginResponse) {
        self.loginResponse = response
        persistUser()
    }

    var isLoggedIn: Bool {
        loginResponse != nil
    }
    
    func logout() {
        loginResponse = nil
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    private func persistUser() {
        guard let loginResponse else {
            UserDefaults.standard.removeObject(forKey: userKey)
            return
        }
        
        if let data = try? JSONEncoder().encode(loginResponse) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
    
    private func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            return
        }
        self.loginResponse = decoded
    }
}

