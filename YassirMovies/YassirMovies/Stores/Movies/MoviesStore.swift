//
//  MoviesStore.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

protocol MoviesStoreProtocol {
	func fetchMovies(page: Int) async throws -> MoviesResponse
	func fetchMovieDetails(movieId: Int) async throws -> Movie
}

final class MoviesStore: MoviesStoreProtocol {
	
	// MARK: - MoviesStoreProtocol
	
	func fetchMovies(page: Int) async throws -> MoviesResponse {
		try await NetworkManager.shared.request(endpoint: MainAPI.getTrendingMovies(page))
	}
	
	func fetchMovieDetails(movieId: Int) async throws -> Movie {
		try await NetworkManager.shared.request(endpoint: MainAPI.getMovieDetails(movieId))
	}
	
}

final class MockMoviesStore: MoviesStoreProtocol {
	
	// MARK: - MoviesStoreProtocol
	
	func fetchMovies(page: Int) async throws -> MoviesResponse { .mock }
	
	func fetchMovieDetails(movieId: Int) async throws -> Movie { .mock }
	
}
