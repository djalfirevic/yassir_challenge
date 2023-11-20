//
//  API+Extensions.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

extension API {
	
	var scheme: HTTPScheme { .https }
	var baseURL: String { "api.themoviedb.org" }
	var headerTypes: [HTTPHeaderField: String] {[
			.contentType: "application/json",
			.accept: "application/json"
		]
	}
	
}
