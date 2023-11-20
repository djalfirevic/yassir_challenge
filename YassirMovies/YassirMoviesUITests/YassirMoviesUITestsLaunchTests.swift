//
//  YassirMoviesUITestsLaunchTests.swift
//  YassirMoviesUITests
//
//  Created by Djuro on 11/20/23.
//

import XCTest

final class YassirMoviesUITestsLaunchTests: XCTestCase {

	// MARK: - Setup
	
    override class var runsForEachTargetApplicationUIConfiguration: Bool { true }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
	
	// MARK: - Tests

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
	
}
