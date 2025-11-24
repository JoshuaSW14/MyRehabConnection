//
//  ExerciseStep.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//


import Foundation

struct ExerciseStep: Codable {
    let caption: String
    let thumbnail: String
    let imageTs: Int
    
    enum CodingKeys: String, CodingKey {
        case caption
        case thumbnail
        case imageTs = "image_ts"
    }
}
