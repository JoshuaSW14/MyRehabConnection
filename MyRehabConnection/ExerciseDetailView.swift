//
//  ExerciseDetailView.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//


import SwiftUI

struct ExerciseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    let video: Video
    
    private var stepsArray: [(Int, ExerciseStep)] {
        video.exercise.steps
            .compactMap { key, step in Int(key).map { ($0, step) } }
            .sorted { $0.0 < $1.0 }
    }
    
    private var domain: String {
        authManager.loginResponse?.domain ?? "https://myrehabconnection.com/portal"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MRCHeader(
                title: "My Rehab Connection",
                showsBackButton: true,
                onBackTapped: { dismiss() }
            )
            
            // Top buttons row
            HStack {
                Button("Back to Exercises") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                NavigationLink {
                    VideoPlayerView(video: video)
                        .navigationBarHidden(true)
                } label: {
                    Text("Video")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(.systemGray6))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(video.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    
                    ForEach(stepsArray, id: \.0) { index, step in
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = imageURL(for: step.thumbnail) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let img):
                                        img
                                            .resizable()
                                            .scaledToFit()
                                    default:
                                        Rectangle()
                                            .fill(Color.mrcLightGray)
                                            .frame(height: 160)
                                    }
                                }
                            }
                            
                            Text("Step \(index)")
                                .font(.subheadline)
                                .bold()
                            
                            Text(step.caption)
                                .font(.body)
                        }
                        .padding(.bottom, 12)
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private func imageURL(for thumbnail: String) -> URL? {
        let path = video.exercise.info.mediaDir + thumbnail
        return URL(string: domain + path)
    }
}
