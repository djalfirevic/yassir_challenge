//
//  RemoteImageView.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

import SwiftUI
import Kingfisher

enum RemoteImageViewState {
	case loading
	case success
	case error
}

struct RemoteImageView<Content: View>: View {
	
	// MARK: - Properties
	
	let url: URL?
	let contentMode: SwiftUI.ContentMode
	let placeholder: (RemoteImageViewState) -> Content?
	@State private var state: RemoteImageViewState = .loading
	
	// MARK: - Initialization
	
	init(url: URL?, contentMode: SwiftUI.ContentMode = .fill, @ViewBuilder placeholder: @escaping (RemoteImageViewState) -> Content?) {
		self.url = url
		self.contentMode = contentMode
		self.placeholder = placeholder
	}
	
	// MARK: - View
	
	var body: some View {
		KFImage.url(url)
			.placeholder { progress in
				placeholder(state)
			}
			.fade(duration: 0.3)
			.resizable()
			.onProgress { receivedSize, totalSize in  }
			.onSuccess { result in
				state = .success
			}
			.onFailure { error in
				state = .error
			}
			.aspectRatio(contentMode: contentMode)
	}
	
}

// MARK: - Previews

#Preview {
	RemoteImageView(
		url: URL(string: "https://d37caf01gv1fnk.cloudfront.net/8786ac2f-554a-481a-aa45-078dea4989db/6f918b5c-9c9a-47d0-b716-1dbfe4d79055.jpeg"),
		contentMode: .fill
	) { state in
		Text("Loading")
	}
	.padding(10)
}
