//
//  PollViewModel.swift
//  Pollexa
//
//  Created by Turan Çabuk on 5.06.2024.
//

import UIKit


class DiscoverViewModel {
    
    // MARK: - Properties
    private var posts: [Post] = []
    var onPostsUpdated: (() -> Void)?
    private var postProvider: PostProviderProtocol
    
    // Initialize ViewModel and fetch posts
    init(postProvider: PostProviderProtocol = PostProvider.shared) {
        self.postProvider = postProvider
        fetchPosts()
    }
    
    // MARK: - CollectionView Methods
    var numberOfPosts: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    // Fetch posts from the provider
    func fetchPosts() {
        postProvider.fetchAll { [weak self] result in
            switch result {
            case .success(let posts):
                // posts sorted by createdAt
                self?.posts = posts.sorted(by: { $0.createdAt > $1.createdAt})
                self?.onPostsUpdated?()
            case .failure(let error):
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
    }
}
