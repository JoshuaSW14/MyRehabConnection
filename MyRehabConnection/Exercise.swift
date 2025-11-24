//
//  Exercise.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//


import Foundation

struct Exercise: Codable, Identifiable {
    var id: String { info.exerciseId }
    
    let info: ExerciseInfo
    let steps: [String: ExerciseStep]
}

struct ExerciseInfo: Codable {
    let exerciseId: String
    let lastUpdated: Int
    let mediaDir: String
    let thumbnail: String
    let exerciseName: String
    let video: Int

    enum CodingKeys: String, CodingKey {
        case exerciseId = "exercise_id"
        case lastUpdated = "last_updated"
        case mediaDir = "media_dir"
        case thumbnail
        case exerciseName = "exercise_name"
        case video
    }
}
