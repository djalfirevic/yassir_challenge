//
//  Movie.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

struct Movie: Identifiable, Decodable, Equatable {
	
	// MARK: - Properties
	
	let id: Int
	let title: String
	let overview: String
	let posterPath: String
	let rating: Double
	var imageURL: URL? {
		URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case overview
		case posterPath = "poster_path"
		case rating = "vote_average"
	}
	
}

extension Movie {
	
	static var mock: Movie {
		Movie(
			id: 872585,
			title: "Oppenheimer",
			overview: "The story of J. Robert Oppenheimer's role in the development of the atomic bomb during World War II.",
			posterPath: "/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
			rating: 8.2
		)
	}
	
}
