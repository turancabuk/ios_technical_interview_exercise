//
//  PollCollectionViewCell.swift
//  Pollexa
//
//  Created by Turan Çabuk on 5.06.2024.
//

import UIKit

class PollCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    // Properties has been created with lazy initialization for optimal memory usage.
    lazy var userImageView = createCustomImageView(cornerRadius: 20)
    lazy var userNameLabel = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 16), numOfLines: 1)
    lazy var timeAgoLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 14), numOfLines: 1)
    lazy var optionsImageView = createCustomImageView(cornerRadius: 0)
    lazy var seperatorImageView = createCustomImageView(cornerRadius: 0)
    lazy var lastVotedLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 14), numOfLines: 1)
    lazy var postContentLabel = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 14), numOfLines: 0)
    lazy var optionImageView = createCustomImageView(cornerRadius: 12)
    lazy var optionImageView1 = createCustomImageView(cornerRadius: 12)
    lazy var totalVotesLabel = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 12), numOfLines: 1)
    lazy var percentageLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 12), numOfLines: 1)
    lazy var percentageLabel1 = createCustomLabel(font: UIFont.systemFont(ofSize: 12), numOfLines: 1)

    private var votesForOption1 = 0
    private var votesForOption2 = 0
    private var totalVotes = 0
    private var hasVoted = false
    
    lazy var userInfoStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .horizontal, spacing: 8)
        stackView.alignment = .center
        let userImageAndTimeStackView = createCustomStackView(axis: .horizontal, spacing: 2)
        userImageAndTimeStackView.addArrangedSubview(userNameLabel)
        userImageAndTimeStackView.addArrangedSubview(timeAgoLabel)
        userImageAndTimeStackView.addArrangedSubview(optionsImageView)
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(userImageAndTimeStackView)
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .vertical, spacing: -4)
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.addArrangedSubview(lastVotedLabel)
        stackView.addArrangedSubview(postContentLabel)
        return stackView
    }()
    
    lazy var optionStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .horizontal, spacing: 8)
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(optionImageView)
        stackView.addArrangedSubview(optionImageView1)
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var uniqueContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Layout Constraints for subviews
    private func setupLayout() {
        contentView.addSubview(uniqueContainerView)
        uniqueContainerView.addSubview(userInfoStackView)
        uniqueContainerView.addSubview(seperatorImageView)
        uniqueContainerView.addSubview(contentStackView)
        uniqueContainerView.addSubview(optionStackView)
        uniqueContainerView.addSubview(totalVotesLabel)
        
        createVoteButton(to: optionImageView, isFirstOption: true)
        createVoteButton(to: optionImageView1, isFirstOption: false)
        
        createPercentageLabel(to: optionImageView, label: percentageLabel)
        createPercentageLabel(to: optionImageView1, label: percentageLabel1)
        
        NSLayoutConstraint.activate([
            uniqueContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uniqueContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            uniqueContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            uniqueContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            userImageView.heightAnchor.constraint(equalToConstant: 32),
            userImageView.widthAnchor.constraint(equalToConstant: 32),
            
            userInfoStackView.topAnchor.constraint(equalTo: uniqueContainerView.topAnchor, constant: 8),
            userInfoStackView.heightAnchor.constraint(equalTo: uniqueContainerView.heightAnchor, multiplier: 1/8),
            userInfoStackView.widthAnchor.constraint(equalTo: uniqueContainerView.widthAnchor, multiplier: 0.9),
            userInfoStackView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            seperatorImageView.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 4),
            seperatorImageView.heightAnchor.constraint(equalToConstant: 4),
            seperatorImageView.widthAnchor.constraint(equalTo: uniqueContainerView.widthAnchor, multiplier: 0.9),
            seperatorImageView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: seperatorImageView.bottomAnchor, constant: 8),
            contentStackView.heightAnchor.constraint(equalTo: uniqueContainerView.heightAnchor, multiplier: 0.2),
            contentStackView.widthAnchor.constraint(equalTo: uniqueContainerView.widthAnchor, multiplier: 0.9),
            contentStackView.leadingAnchor.constraint(equalTo: uniqueContainerView.leadingAnchor, constant: 12),
            
            optionStackView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 6),
            optionStackView.heightAnchor.constraint(equalTo: uniqueContainerView.heightAnchor, multiplier: 0.45),
            optionStackView.widthAnchor.constraint(equalTo: seperatorImageView.widthAnchor),
            optionStackView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            totalVotesLabel.topAnchor.constraint(equalTo: optionStackView.bottomAnchor, constant: 14),
            totalVotesLabel.heightAnchor.constraint(equalToConstant: 14),
            totalVotesLabel.widthAnchor.constraint(equalTo: seperatorImageView.widthAnchor),
            totalVotesLabel.leadingAnchor.constraint(equalTo: optionStackView.leadingAnchor),
        ])
        percentageLabel.isHidden = true
        percentageLabel1.isHidden = true
    }
    // MARK: - Factory UI Methods.
    private func createCustomImageView(cornerRadius: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func createCustomLabel(font: UIFont, numOfLines: Int) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createCustomStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createVoteButton(to imageView: UIImageView, isFirstOption: Bool) {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.addTarget(self, action: isFirstOption ? #selector(voteButtonTapped1) : #selector(voteButtonTapped2), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            button.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func createPercentageLabel(to imageView: UIImageView, label: UILabel) {
        label.text = "%"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 30),
            label.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func resetCell() {
        hasVoted = false
        votesForOption1 = 0
        votesForOption2 = 0
        totalVotes = 0
        
        optionImageView.subviews.compactMap { $0 as? UIButton }.forEach { $0.isHidden = false}
        optionImageView1.subviews.compactMap { $0 as? UIButton }.forEach { $0.isHidden = false}
        percentageLabel.text = "0%"
        percentageLabel1.text = "0%"
        percentageLabel.isHidden = true
        percentageLabel1.isHidden = true
        totalVotesLabel.text = "total Votes: 0"
    }

    @objc private func voteButtonTapped1() {
        guard !hasVoted else {return}
        hasVoted = true
        votesForOption1 += 1
        totalVotes += 1
        updateVoteUI()
    }
    @objc private func voteButtonTapped2() {
        guard !hasVoted else {return}
        hasVoted = true
        votesForOption2 += 1
        totalVotes += 1
        updateVoteUI()
    }
    
    private func updateVoteUI() {
        let option1Percentage = totalVotes == 0 ? 0 : (votesForOption1 * 100) / totalVotes
        let option2Percentage = totalVotes == 0 ? 0 : (votesForOption2 * 100) / totalVotes
        
        percentageLabel.text = "\(option1Percentage)%"
        percentageLabel1.text = "\(option2Percentage)%"
        totalVotesLabel.text = "Total Votes: \(totalVotes)"
        
        percentageLabel.isHidden = false
        percentageLabel1.isHidden = false
        
        optionImageView.subviews.compactMap { $0 as? UIButton }.forEach { $0.isHidden = true}
        optionImageView1.subviews.compactMap { $0 as? UIButton }.forEach { $0.isHidden = true}
    }
    
    // Configuring cell with post data
    func configure(with post: Post) {
        resetCell()
        
        userImageView.image = post.user.image
        userNameLabel.text = post.user.username
        timeAgoLabel.text = postContentSinceToday(post.createdAt)
        timeAgoLabel.textColor = .lightGray
        optionsImageView.image = UIImage(named: "optionsIcon")
        seperatorImageView.image = UIImage(named: "Seperator")
        lastVotedLabel.text = "Last Voted"
        lastVotedLabel.textColor = .darkGray
        postContentLabel.numberOfLines = 2
        seperatorImageView.translatesAutoresizingMaskIntoConstraints = false
        postContentLabel.text = post.content
        
        if post.options.count > 0 {
            optionImageView.image = post.options[0].image
        }
        
        if post.options.count > 1 {
            optionImageView1.image = post.options[1].image
        }
        
        totalVotesLabel.text = "\(post.options.count) Total Votes"
        totalVotesLabel.textColor = .lightGray
        
        if hasVoted {
            updateVoteUI()
        }
    }
    func postContentSinceToday(_ date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
        let now = Date()
        let dateString = formatter.string(from: date, to: now) ?? ""
        return "\(dateString) ago"
    }
}
