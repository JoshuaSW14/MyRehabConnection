//
//  VideoListView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//
import SwiftUI

struct VideoListView: View {
    @EnvironmentObject var authManager: AuthManager
    var onMenuTapped: () -> Void
    
    @State private var videos: [Video] = []
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            MRCHeader(title: "My Rehab Connection", onMenuTapped: onMenuTapped)
            
            VStack(spacing: 4) {
                Text("My Exercises")
                    .font(.title2)
                    .bold()
                    .padding(.top, 8)
                Divider()
            }
            .background(Color.white)
            .onAppear { loadVideos() }
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.mrcLightGray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(videos) { video in
                            NavigationLink {
                                ExerciseDetailView(video: video)
                                    .navigationBarHidden(true)
                            } label: {
                                videoRow(for: video)
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .padding(.leading, 72)
                        }
                    }
                    .background(Color.white)
                }
                .background(Color.mrcLightGray)
            }
        }
        .background(Color.mrcLightGray)
        .onAppear {
            loadVideos()
        }
    }
    
    // MARK: - Helpers
    
    private func loadVideos() {
        guard let loginResponse = authManager.loginResponse else {
            errorMessage = "Not authenticated"
            videos = []
            return
        }
        errorMessage = nil
        videos = VideoService.shared.videos(from: loginResponse)
    }
    
    @ViewBuilder
    private func videoRow(for video: Video) -> some View {
        HStack(spacing: 12) {
            // Thumbnail
            if let thumb = video.thumbnailUrl {
                AsyncImage(url: thumb) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.white
                    }
                }
                .frame(width: 64, height: 48)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.mrcBorder, lineWidth: 1)
                )
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 64, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.mrcBorder, lineWidth: 1)
                    )
            }
            
            // Title text
            Text(video.title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.mrcLightGray)
    }
}

