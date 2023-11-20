//
//  MovieDestination.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

enum MovieDestination: Hashable & Identifiable {
	case details(Int)
	
	var id: Self { self }
	
	// MARK: - Hashable
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	// MARK: - Equatable
	
	static func == (lhs: MovieDestination, rhs: MovieDestination) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
	
}
