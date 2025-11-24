//
//  VideoPlayerView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let video: Video
    
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                MRCHeader(
                    title: "My Rehab Connection",
                    showsBackButton: true,
                    onBackTapped: { dismiss() }
                )
                
                Spacer()
                
                if let player = player {
                    VideoPlayer(player: player)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView("Loading video…")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .onAppear { setupPlayer() }
        .onDisappear { player?.pause() }
        .navigationBarBackButtonHidden(true)   // hide system back arrow
        .navigationBarHidden(true)
    }
    
    private func setupPlayer() {
        player = AVPlayer(url: video.videoUrl)
    }
}
