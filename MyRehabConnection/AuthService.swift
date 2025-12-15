//
//  AuthService.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation
import CryptoKit

final class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    // Point this to wherever your login.php lives
    // (e.g. https://myrehabconnection.com/portal/login.php)
    private let loginURL = URL(string: "https://myrehabconnection.com/portal/app/login.php")!
    
    func login(username: String, password: String) async throws -> LoginResponse {
        // 1) Match Cordova hashing
        let hashpass = isHashed(password) ? password : hashPassword(password)
        
        // 2) Build URL with query params ?username=...&password=...
        var components = URLComponents(url: loginURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: hashpass)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"   // jQuery default
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // (Optional debug – keep this for now)
        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode)
        }
        if let raw = String(data: data, encoding: .utf8) {
            print("RAW BODY:\n\(raw)")
        }
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        // Persist the username (email) locally on successful login
        UserDefaults.standard.set(username, forKey: "MRC.lastLoginEmail")
        print("[AuthService] Saved lastLoginEmail to UserDefaults: \(UserDefaults.standard.string(forKey: "MRC.lastLoginEmail") ?? "nil")")
        
        return decoded
    }

    // small helper for safe form encoding
    private func urlEncode(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
    }
    
    private let md5Key = "#RCgray"  // same as common.js

    private func isHashed(_ str: String) -> Bool {
        // /^[a-f0-9]{32}$/
        let regex = try! NSRegularExpression(pattern: "^[a-f0-9]{32}$")
        let range = NSRange(location: 0, length: str.utf16.count)
        return regex.firstMatch(in: str, options: [], range: range) != nil
    }

    private func hashPassword(_ password: String) -> String {
        let combined = password + md5Key
        let digest = Insecure.MD5.hash(data: Data(combined.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

}
