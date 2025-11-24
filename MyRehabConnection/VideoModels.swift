//
//  VideosView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation

struct Video: Identifiable {
    let id: String
    let title: String
    let description: String?
    let thumbnailUrl: URL?
    let videoUrl: URL
    let exercise: Exercise      // 👈 add this
}
