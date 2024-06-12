//
//  DiscoverViewControllerUITests.swift
//  DiscoverViewControllerUITests
//
//  Created by Turan Çabuk on 12.06.2024.
//

import XCTest

final class DiscoverViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_discoverViewControllerUIElements() {
        // Check for avability of "Discover" label
        let discoverLabel = app.staticTexts["discoverLabel"]
        XCTAssertTrue(discoverLabel.exists, "The Discover label does not exist")
        
        // Check for avability of Avatar image
        let avatarImageView = app.images["avatarImageView"]
        XCTAssertTrue(avatarImageView.exists, "The avatar imageView does not exist")
        
        // Check for avability of "ActivePoll" label
        let activePollLabel = app.staticTexts["activePollLabel"]
        XCTAssertTrue(activePollLabel.exists, "The Active Polls label does not exist")
        
        // Check for avability of collectionView
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists, "The postsCollectionView does not exist")
        
        // Check for scroll the collectionView
        collectionView.swipeUp()
        
        // Check for first cell in collectionView
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell in the collectionView does not exist")
    }
    
    func test_voteStatusUpdate() throws {
        // Tap the first cell in collectionView and check the vote status
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists, "The postsCollectionView does not exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell in the collectionView does not exist")
        
        firstCell.tap()
    }
}
