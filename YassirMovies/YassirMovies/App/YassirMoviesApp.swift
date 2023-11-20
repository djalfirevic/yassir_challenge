//
//  YassirMoviesApp.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import SwiftUI

@main
struct YassirMoviesApp: App {
	
	// MARK: - App
	
    var body: some Scene {
        WindowGroup {
			MoviesView(viewModel: MoviesViewModel())
        }
    }
	
}
