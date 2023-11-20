//
//  MoviesView.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import SwiftUI

struct MoviesView: View {
	
	// MARK: - Properties
	
	@ObservedObject var viewModel: MoviesViewModel
	
	// MARK: - View
	
    var body: some View {
		if viewModel.isLoading {
			ProgressView()
				.tint(.purple)
		} else {
			NavigationStack {
				List {
					ForEach(viewModel.movies) { movie in
						NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieId: movie.id))) {
							MovieRow(movie: movie)
								.onAppear {
									if movie == viewModel.movies.last && viewModel.hasMore {
										viewModel.performAction(.onFetch)
									}
								}
						}
					}
					
					if viewModel.hasMore {
						ProgressView()
							.tint(.purple)
					}
				}
				.listStyle(.plain)
				.accessibilityLabel("moviesListView")
				.navigationTitle("Yassir")
				.refreshable {
					viewModel.performAction(.onRefresh)
				}
				.onAppear {
					viewModel.performAction(.onAppear)
				}
			}
		}
    }
	
	// MARK: - Private API
	
	@ViewBuilder
	private func MovieRow(movie: Movie) -> some View {
		HStack(alignment: .top) {
			RemoteImageView(url: movie.imageURL) { phase in
				ProgressView()
					.tint(.purple)
			}
			.frame(width: 80, height: 100)
			.aspectRatio(contentMode: .fill)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			
			VStack(alignment: .leading) {
				Text(movie.title)
					.font(.headline)
				
				Text(movie.overview)
					.font(.caption)
			}
		}
	}
	
}

#Preview {
	MoviesView(viewModel: MoviesViewModel())
}
