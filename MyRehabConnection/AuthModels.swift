//
//  AuthModels.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation

import Foundation

struct LoginResponse: Codable {
    let patientId: String
    let domain: String
    let clinic: Clinic
    let exercises: [Exercise]

    enum CodingKeys: String, CodingKey {
        case patientId = "patient_id"
        case domain
        case clinic
        case exercises
    }
}
