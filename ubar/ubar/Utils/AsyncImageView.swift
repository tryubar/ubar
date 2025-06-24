//
//  AsyncImageView.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import SwiftUI

// MARK: - Custom Async Image View
struct AsyncImageView: View {
    let url: String?
    let placeholder: String
    
    var body: some View {
        if let url = url, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                PlaceholderView(systemName: placeholder)
            }
        } else {
            PlaceholderView(systemName: placeholder)
        }
    }
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let systemName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: systemName)
                    .font(.title)
                    .foregroundColor(.gray)
            )
    }
}

#Preview {
    AsyncImageView(url: nil, placeholder: "wineglass")
        .frame(width: 100, height: 100)
}
