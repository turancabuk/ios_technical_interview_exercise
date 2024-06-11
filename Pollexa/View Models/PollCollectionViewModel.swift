//
//  PollViewModel.swift
//  Pollexa
//
//  Created by Turan Çabuk on 10.06.2024.
//

import UIKit

protocol PollViewModelDelegate: AnyObject {
    func updateVoteUI()
}
class PollCollectionViewModel {
    
    // MARK: - Properties.
    weak var delegate: PollViewModelDelegate?
    var post: Post?
    var onDataUpdated: (() -> Void)?
    private(set) var votesForOption1 = 0
    private(set) var votesForOption2 = 0
    private(set) var totalVotes = 0
    private(set) var hasVoted = false
    private(set) var postId: String?
    private(set) var lastVotedDate: Date?
    private var timer: Timer?
    
    // MARK: - Configuration
    func configure(with post: Post, voteStatus: [String: (option: Int, date: Date)]) {
        reset()
        self.post = post
        self.postId = post.id
        
        if let vote = voteStatus[post.id] {
            hasVoted = true
            lastVotedDate = vote.date
            if vote.option == 1 {
                votesForOption1 += 1
            }else if vote.option == 2 {
                votesForOption2 += 1
            }
            totalVotes = votesForOption1 + votesForOption2
            startTimer()
        }else{
            totalVotes = 0
        }
        onDataUpdated?()
    }
    
    // MARK: - Voting
    func vote(option: Int) {
        guard !hasVoted else {return}
        hasVoted = true
        
        if option == 1 {
            votesForOption1 += 1
        }else{
            votesForOption2 += 1
        }
        totalVotes = votesForOption1 + votesForOption2
        lastVotedDate = Date()
        onDataUpdated?()
        startTimer()
    }
    
    // MARK: Calculations
    func getOptionPercentage(option: Int) -> Int {
        guard totalVotes > 0 else {return 0}
//        return option == 1 ? (votesForOption1 * 100) / totalVotes : (votesForOption2 * 100) / totalVotes
        guard totalVotes > 0 else { return 0 }
        if option == 1 {
            return (votesForOption1 * 100) / totalVotes
        } else {
            return (votesForOption2 * 100) / totalVotes
        }
    }
    
    func getTotalVotesText() -> String {
        return totalVotes == 1 ? "\(totalVotes) Total Vote" : "\(totalVotes) Total Votes"
    }
    
    func getLastVotedText() -> String {
        guard let lastVotedDate = lastVotedDate else {return "No Vote Yet"}
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        formatter.maximumUnitCount = 1
        let now = Date()
        let dateString = formatter.string(from: lastVotedDate, to:  now) ?? ""
        return "Last Voted \(dateString) ago"
    }
    
    // MARK: - Helper Method
    private func reset() {
        votesForOption1 = 0
        votesForOption2 = 0
        totalVotes = 0
        hasVoted = false
        lastVotedDate = nil
        stopTimer()
    }
    
    // MARK: - Timer Management
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerFired() {
        onDataUpdated?()
    }
}
