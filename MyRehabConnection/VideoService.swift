//
//  VideoService.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation

final class VideoService {
    static let shared = VideoService()
    
    private init() {}
    
    func videos(from loginResponse: LoginResponse) -> [Video] {
        loginResponse.exercises.compactMap { exercise in
            makeVideo(from: exercise, domain: loginResponse.domain)
        }
    }
    
    private func makeVideo(from exercise: Exercise, domain: String) -> Video? {
        let info = exercise.info
        
        // ✅ Build video URL exactly like common.js:
        // ls.domain + exercise.info.media_dir + 'video.mp4'
        let base = domain       // e.g. "https://myrehabconnection.com/portal"
        let videoUrlString = "\(base)\(info.mediaDir)video.mp4"
        
        print("VIDEO URL:", videoUrlString)
        guard let videoUrl = URL(string: videoUrlString) else {
            print("Invalid video URL: \(videoUrlString)")
            return nil
        }
        
        // ✅ Thumbnail: same base + media_dir + thumbnail filename
        let thumbUrl: URL?
        if !info.thumbnail.isEmpty {
            let thumbString = "\(base)\(info.mediaDir)\(info.thumbnail)"
            thumbUrl = URL(string: thumbString)
        } else {
            thumbUrl = nil
        }
        
        // Use first step caption as description
        let firstStepCaption: String? = {
            let sortedSteps = exercise.steps.sorted {
                (Int($0.key) ?? 0) < (Int($1.key) ?? 0)
            }
            return sortedSteps.first?.value.caption
        }()
        
        return Video(
            id: info.exerciseId,
            title: info.exerciseName,
            description: firstStepCaption,
            thumbnailUrl: thumbUrl,
            videoUrl: videoUrl,
            exercise: exercise           // 👈 new
        )
    }
}


