//
//  YassirMoviesTests.swift
//  YassirMoviesTests
//
//  Created by Djuro on 11/20/23.
//

import XCTest
import Combine
@testable import YassirMovies

final class YassirMoviesTests: XCTestCase {
	
	// MARK: - Properties
	
	private var cancellables = Set<AnyCancellable>()
	
	// MARK: - Tests
	
	@MainActor
	func testMoviesViewModel() {
		let expectation = expectation(description: "Test refresh")
		let sut = MoviesViewModel(moviesStore: MockMoviesStore())
		sut.$movies
			.sink(receiveValue: { movies in
				if !movies.isEmpty {
					expectation.fulfill()
					XCTAssertTrue(movies.count == 1, "The movies list contains 1 movie")
				}
			})
			.store(in: &cancellables)
		
		sut.performAction(.onRefresh)
		
		wait(for: [expectation], timeout: 3)
	}
	
}
