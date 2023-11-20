//
//  MovieDetailsViewModel.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

@MainActor
final class MovieDetailsViewModel: ObservableObject {
	
	enum Action {
		case onAppear
	}
	
	// MARK: - Properties
	
	@Published var isLoading = false
	@Published var imageUrl: URL?
	@Published var title = ""
	@Published var overview = ""
	@Published var rating = 0.0
	private let movieId: Int
	private let moviesStore: MoviesStoreProtocol
	
	// MARK: - Initialization
	
	init(movieId: Int, moviesStore: MoviesStoreProtocol = MoviesStore()) {
		self.movieId = movieId
		self.moviesStore = moviesStore
	}
	
	// MARK: - Public API
	
	func performAction(_ action: Action) {
		switch action {
		case .onAppear:
			fetchDetails()
		}
	}
	
	// MARK: - Private API
	
	private func fetchDetails() {
		isLoading = true
		
		Task {
			defer { isLoading  = false }
			
			do {
				let response: Movie = try await moviesStore.fetchMovieDetails(movieId: movieId)
				self.imageUrl = response.imageURL
				self.title = response.title
				self.overview = response.overview
				self.rating = response.rating
			} catch {
				Logger.log(message: "Fetching movie details: \(error)", type: .error)
			}
		}
	}
	
}
