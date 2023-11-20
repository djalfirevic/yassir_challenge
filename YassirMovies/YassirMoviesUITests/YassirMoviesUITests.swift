//
//  YassirMoviesUITests.swift
//  YassirMoviesUITests
//
//  Created by Djuro on 11/20/23.
//

import XCTest

final class YassirMoviesUITests: XCTestCase {

	// MARK: - Properties
	
	var application: XCUIApplication!
	
	// MARK: - Setup
	
    override func setUpWithError() throws {
		continueAfterFailure = false
		application = XCUIApplication()
		application.launch()
		XCUIDevice.shared.orientation = .portrait
    }
	
	// MARK: - Tests

    func testMoviesView() throws {
		let itemsCollectionView = application.collectionViews["moviesListView"]
		
		XCTAssertTrue(itemsCollectionView.exists, "The movies list view exists")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
	
}
