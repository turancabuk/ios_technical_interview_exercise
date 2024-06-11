//
//  DiscoverViewModelTests.swift
//  DiscoverViewModelTests
//
//  Created by Turan Çabuk on 11.06.2024.
//

import XCTest
@testable import Pollexa

final class DiscoverViewModelTests: XCTestCase {
    
    var viewModel: DiscoverViewModel!
    var mockPosts: [Post]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPosts = [
            Post(
                id: "1",
                createdAt: Date(),
                content: "Poll 1 content",
                options: [
                    Post.Option(id: "1", image: UIImage(systemName: "circle")!),
                    Post.Option(id: "2", image: UIImage(systemName: "circle.fill")!),
                ],
                user: User(id: "1", username: "user1", image: UIImage(systemName: "person.fill")!)
            ),
            Post(
                id: "2",
                createdAt: Date().addingTimeInterval(-100),
                content: "Poll 2 content",
                options: [
                    Post.Option(id: "1", image: UIImage(systemName: "circle")!),
                    Post.Option(id: "2", image: UIImage(systemName: "circle.fill")!),
                ],
                user: User(id: "2", username: "user2", image: UIImage(systemName: "person.fill")!)
            ),
            Post(
                id: "3",
                createdAt: Date().addingTimeInterval(-200),
                content: "Poll 3 content",
                options: [
                    Post.Option(id: "1", image: UIImage(systemName: "circle")!),
                    Post.Option(id: "2", image: UIImage(systemName: "circle.fill")!),
                ],
                user: User(id: "3", username: "user3", image: UIImage(systemName: "person.fill")!)
            )
        ]
        viewModel = DiscoverViewModel(postProvider: MockPostProvider(posts: mockPosts))
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockPosts = nil
        try super.tearDownWithError()
    }
    
    func test_numberOfPosts() {
        XCTAssertEqual(viewModel.numberOfPosts, mockPosts.count)
    }
    
    func test_postOfIndex() {
        for (index, post) in mockPosts.enumerated() {
            XCTAssertEqual(viewModel.post(at: index).id, post.id)
            XCTAssertEqual(viewModel.post(at: index).content, post.content)
            XCTAssertEqual(viewModel.post(at: index).createdAt, post.createdAt)
            XCTAssertEqual(viewModel.post(at: index).options.count, post.options.count)
            XCTAssertEqual(viewModel.post(at: index).user.id, post.user.id)
        }
    }
    
    func test_fetchPosts_succes() {
        let expectation = self.expectation(description: "FetchPosts")
        
        viewModel.onPostsUpdated = {
            expectation.fulfill()
        }
        
        viewModel.fetchPosts()
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(viewModel.numberOfPosts, mockPosts.count)
    }
    
    func test_fetchPosts_failure() {
        viewModel = DiscoverViewModel(postProvider: MockPostProvider(error: NSError(domain: "Test", code: 1, userInfo: nil)))
        viewModel.fetchPosts()
        XCTAssertEqual(viewModel.numberOfPosts, 0)
    }
}

class MockPostProvider: PostProviderProtocol {
    
    var posts: [Post]?
    var error: Error?
    
    init(posts: [Post]? = nil, error: Error? = nil) {
        self.posts = posts
        self.error = error
    }
    
    func fetchAll(completion: @escaping (Result<[Post], any Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        }else{
            completion(.success(posts ?? []))
        }
    }
}
