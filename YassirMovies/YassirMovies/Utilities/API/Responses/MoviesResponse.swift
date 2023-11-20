//
//  MoviesResponse.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

struct MoviesResponse: Decodable {
	
	// MARK: - Properties
	
	let page: Int
	let results: [Movie]
	let totalPages: Int
	let totalResults: Int
	
	enum CodingKeys: String, CodingKey {
		case page
		case results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
	
}

extension MoviesResponse {
	
	static var mock: MoviesResponse {
		MoviesResponse(
			page: 1,
			results: [.mock],
			totalPages: 1,
			totalResults: 1
		)
	}
	
}
