//
//  MRCHeader.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import SwiftUI

struct MRCHeader: View {
    var title: String
    var onMenuTapped: (() -> Void)? = nil
    var showsBackButton: Bool = false
    var onBackTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.mrcRed
                .ignoresSafeArea(edges: [.horizontal])
            
            HStack {
                // Left icon: either back, menu, or empty spacer
                if showsBackButton {
                    Button {
                        onBackTapped?()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                } else if let onMenuTapped {
                    Button {
                        onMenuTapped()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                } else {
                    // spacer to keep title centered
                    Color.clear.frame(width: 24, height: 24)
                }
                
                Spacer()
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                // right spacer to balance layout
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(height: 52)
    }
}
