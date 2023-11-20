//
//  MoviesViewModel.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
	
	enum Action {
		case onAppear
		case onFetch
		case onRefresh
	}
	
	// MARK: - Properties
	
	@Published var isLoading = false
	@Published var movies = [Movie]()
	var hasMore: Bool {
		totalPages > page
	}
	private var page = 1
	private var totalPages = 0
	private let moviesStore: MoviesStoreProtocol
	
	// MARK: - Initialization
	
	init(moviesStore: MoviesStoreProtocol = MoviesStore()) {
		self.moviesStore = moviesStore
	}
	
	// MARK: - Public API
	
	func performAction(_ action: Action) {
		switch action {
		case .onAppear:
			if movies.isEmpty {
				fetchTrendingMovies(reload: true)
			}
		case .onFetch:
			fetchTrendingMovies()
		case .onRefresh:
			fetchTrendingMovies(reload: true)
		}
	}
	
	// MARK: - Private API
	
	private func fetchTrendingMovies(reload: Bool = false) {
		Task {
			defer { isLoading  = false }
			
			do {
				if reload {
					isLoading = true
					page = 1
				}
				
				let response: MoviesResponse = try await moviesStore.fetchMovies(page: page)
				
				if reload {
					self.movies = response.results
				} else {
					self.movies.append(contentsOf: response.results)
				}
				
				self.totalPages = response.totalPages
				
				if self.page + 1 < self.totalPages {
					self.page += 1
				}
			} catch {
				Logger.log(message: "Fetching movies: \(error)", type: .error)
			}
		}
	}
	
}
