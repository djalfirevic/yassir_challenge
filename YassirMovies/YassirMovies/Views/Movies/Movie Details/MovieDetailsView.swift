//
//  MovieDetailsView.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation
import SwiftUI

struct MovieDetailsView: View {
	
	// MARK: - Properties
	
	@ObservedObject var viewModel: MovieDetailsViewModel
	
	// MARK: - View
	
	var body: some View {
		ScrollView {
			VStack {
				if viewModel.isLoading {
					ProgressView()
						.tint(.purple)
				} else {
					RemoteImageView(url: viewModel.imageUrl) { phase in
						ProgressView()
							.tint(.purple)
					}
					.aspectRatio(contentMode: .fit)
					.frame(height: 400)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					
					VStack(alignment: .leading) {
						Text(viewModel.title)
							.font(.headline)
						
						Text(viewModel.overview)
							.font(.caption)
						
						RatingView(rating: viewModel.rating)
							.padding(.top)
					}
					.padding(.horizontal)
				}
			}
			.navigationTitle("Details")
			.navigationBarTitleDisplayMode(.inline)
		}
		.onAppear {
			viewModel.performAction(.onAppear)
		}
	}
	
}

#Preview {
	MovieDetailsView(viewModel: .init(movieId: Movie.mock.id))
}
