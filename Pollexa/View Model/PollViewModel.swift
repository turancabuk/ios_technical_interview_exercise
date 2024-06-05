//
//  PollViewModel.swift
//  Pollexa
//
//  Created by Turan Çabuk on 5.06.2024.
//

import UIKit

class PollViewModel {
    
    // MARK: - Properties
    private let posts: [Post]
    
    init(posts: [Post]) {
        self.posts = posts
    }
    
    // MARK: - CollectionView Data Source Methods
    var numberOfPosts: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    // MARK: - Post Data Methods
    func postContent(at index: Int) -> String {
        return posts[index].content
    }
    
    func postOptions(at index: Int) -> [UIImage] {
        return posts[index].options.map {$0.image}
    }
    
    func postCreatedAt(at index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: posts[index].createdAt)
    }
    
    func totalVotes(at index: Int) -> Int {
        return posts[index].options.count
    }
    
    func optionPercentage(for optionIndex: Int, at postIndex: Int) -> String {
        let totalVotes = self.totalVotes(at: postIndex)
        let votesForOption = 10
        let percentage = (Double(votesForOption) / Double(totalVotes)) * 100
        return String(format: "%0.1f%", percentage)
    }
}
