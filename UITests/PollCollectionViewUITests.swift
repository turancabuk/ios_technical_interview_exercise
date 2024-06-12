//
//  PollCollectionViewUITests.swift
//  DiscoverViewControllerUITests
//
//  Created by Turan Çabuk on 12.06.2024.
//

import XCTest

final class PollCollectionViewUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_pollCollectionViewCellUIElements() throws {
        // Checck for the existense of first cell in the collectionView
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists, "The postsCollectionView does not exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell in the collectionView does not exist")
        
        // Check for the avability of vote buttons
        let voteButton1 = firstCell.buttons["voteButton1"]
        XCTAssertTrue(voteButton1.exists, "The voteButton1 does not exist in the first cell")
        
        let voteButton2 = firstCell.buttons["voteButton2"]
        XCTAssertTrue(voteButton2.exists, "The voteButton2 does not exist in the first cell")
    }
    
    func test_voteButtonInteraction() throws {
        // Check for the first cell in the collectionView
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists, "The postsCollectionView does not exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell in the collectionView does not exist")
        
        // Tap the first vote button
        let voteButton1 = firstCell.buttons["voteButton1"]
        XCTAssertTrue(voteButton1.exists, "The first vote button does not exist in the first cell")
        
        voteButton1.tap()
        
        // Check if percentage labels are visible
        let percentageLabel = firstCell.staticTexts["percentageLabel"]
        XCTAssertTrue(percentageLabel.exists, "The percentageLabel does not exist in the first cell")
        
        let percentageLabel1 = firstCell.staticTexts["percentageLabel1"]
        XCTAssertTrue(percentageLabel1.exists, "Ther percentageLabel1 does not exist in the first cell")
        
        // Check if vote buttons are hidden
        XCTAssertFalse(voteButton1.exists, "The first vote button is still visible in the first cell")
        
        let voteButton2 = firstCell.buttons["voteButton2"]
        XCTAssertFalse(voteButton2.exists, "The second vote button is still visible in the first cell")
        
        // Check if totalVotesLabel exists and its value is updated correctly
        let totalVotesLabel = firstCell.staticTexts["totalVotesLabel"]
        XCTAssertTrue(totalVotesLabel.exists, "The totalVotesLabel does not exist in the first cell")
        
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label contains 'Total Vote'"), object: totalVotesLabel)
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed, "The totalVotesLabel did not update correctly in the first cell")
    }
}
