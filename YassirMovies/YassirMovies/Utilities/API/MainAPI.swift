//
//  MainAPI.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

enum MainAPI: API {
	
	static let apiVersion = "3"
	
	case getTrendingMovies(Int)
	case getMovieDetails(Int)
	
	// MARK: - API
	
	var path: String {
		switch self {
		case .getTrendingMovies:
			return "/\(MainAPI.apiVersion)/discover/movie"
		case .getMovieDetails(let id):
			return "/\(MainAPI.apiVersion)/movie/\(id)"
		}
	}
	var method: HTTPMethod {
		switch self {
		case .getTrendingMovies, .getMovieDetails:
			return .get
		}
	}
	var parameters: [URLQueryItem] {
		switch self {
		case .getTrendingMovies(let page):
			return [
				URLQueryItem(
					name: "page",
					value: "\(page)"
				)
			]
		case .getMovieDetails:
			return []
		}
	}
	var body: Data? { nil }
	
}
