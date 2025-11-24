//
//  APIClient.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case badResponse
    case decodingError
    case serverError(String)
}

final class APIClient {
    static let shared = APIClient()
    
    // TODO: change to your real base URL
    private let baseURL = URL(string: "https://yourserver.com")!
    
    private init() {}
    
    func makeRequest(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil
    ) async throws -> Data {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            // TODO: adjust header format to whatever your backend expects
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }
        
        guard 200..<300 ~= http.statusCode else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(message)
        }
        
        return data
    }
}
