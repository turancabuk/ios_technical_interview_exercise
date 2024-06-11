//
//  PollCollectionViewModelTests.swift
//  DiscoverViewModelTests
//
//  Created by Turan Çabuk on 12.06.2024.
//

import XCTest
@testable import Pollexa

final class PollCollectionViewModelTests: XCTestCase {

    // MARK: - Properties
    var viewModel: PollCollectionViewModel!
    var mockPost: Post!
    var mockVoteStatus: [String: (option: Int, date: Date)]!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = PollCollectionViewModel()
        mockPost = Post(
            id: "1",
            createdAt: Date(),
            content: "Sample Post Content",
            options: [
                Post.Option(id: "1", image: UIImage(systemName: "circle")!),
                Post.Option(id: "2", image: UIImage(systemName: "circle.fill")!)
            ],
            user: User(id: "1", username: "user1", image: UIImage(systemName: "person.fill")!)
        )
        mockVoteStatus = ["1": (option: 1, date: Date().addingTimeInterval(-3600))]
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockPost = nil
        mockVoteStatus = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    func test_configure_withPost_setsPostId() {
        viewModel.configure(with: mockPost, voteStatus: mockVoteStatus)
        XCTAssertEqual(viewModel.postId, mockPost.id)
    }
    
    func test_configure_withPost_setsVoteStatus() {
        viewModel.configure(with: mockPost, voteStatus: mockVoteStatus)
        XCTAssertTrue(viewModel.hasVoted)
        XCTAssertEqual(viewModel.votesForOption1, 1)
        XCTAssertEqual(viewModel.votesForOption2, 0)
    }
    
    func test_vote_incrementsVotes() {
        viewModel.configure(with: mockPost, voteStatus: [:])
        viewModel.vote(option: 1)
        XCTAssertTrue(viewModel.hasVoted)
        XCTAssertEqual(viewModel.votesForOption1, 1)
        XCTAssertEqual(viewModel.totalVotes, 1)
    }
    
    func test_getOptionPercentage_returnsCorrectPercentage() {
        viewModel.configure(with: mockPost, voteStatus: [:])
        viewModel.vote(option: 1)
        XCTAssertEqual(viewModel.getOptionPercentage(option: 1), 100)
        XCTAssertEqual(viewModel.getOptionPercentage(option: 2), 0)
        
        viewModel = PollCollectionViewModel()
        viewModel.configure(with: mockPost, voteStatus: [:])
        viewModel.vote(option: 2)
        XCTAssertEqual(viewModel.getOptionPercentage(option: 1), 0)
        XCTAssertEqual(viewModel.getOptionPercentage(option: 2), 100)
    }
    
    func test_getLastVotedText_returnsCorrectText() {
        viewModel.configure(with: mockPost, voteStatus: mockVoteStatus)
        XCTAssertTrue(viewModel.getLastVotedText().contains("ago"))
    }

}
