//
//  RatingView.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation
import SwiftUI

struct RatingView: View {
	
	// MARK: - Properties
	
	let rating: Double
	
	// MARK: - View
	
	var body: some View {
		HStack {
			ForEach(0..<10) { index in
				Image(systemName: index < Int(rating) ? "star.fill" : "star")
					.foregroundColor(.yellow)
			}
		}
	}
	
}

#Preview {
	RatingView(rating: 7.2)
}
