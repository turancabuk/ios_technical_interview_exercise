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
    lazy var postContentLabel = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 14), numOfLines: 0)
    lazy var optionImageView = createCustomImageView(cornerRadius: 12)
    lazy var optionImageView1 = createCustomImageView(cornerRadius: 12)
    lazy var totalVotesLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 16), numOfLines: 1)
    
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
        uniqueContainerView.addSubview(postContentLabel)
        uniqueContainerView.addSubview(optionStackView)
        uniqueContainerView.addSubview(totalVotesLabel)
        createVoteButton(to: optionImageView)
        createVoteButton(to: optionImageView1)
        
        NSLayoutConstraint.activate([
            uniqueContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uniqueContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            uniqueContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            uniqueContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            userImageView.heightAnchor.constraint(equalToConstant: 32),
            userImageView.widthAnchor.constraint(equalToConstant: 32),
            
            userInfoStackView.topAnchor.constraint(equalTo: uniqueContainerView.topAnchor, constant: 4),
            userInfoStackView.heightAnchor.constraint(equalTo: uniqueContainerView.heightAnchor, multiplier: 1/8),
            userInfoStackView.widthAnchor.constraint(equalTo: uniqueContainerView.widthAnchor, multiplier: 0.9),
            userInfoStackView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            seperatorImageView.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 4),
            seperatorImageView.heightAnchor.constraint(equalToConstant: 4),
            seperatorImageView.widthAnchor.constraint(equalTo: uniqueContainerView.widthAnchor, multiplier: 0.9),
            seperatorImageView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            postContentLabel.topAnchor.constraint(equalTo: seperatorImageView.bottomAnchor, constant: 6),
            postContentLabel.heightAnchor.constraint(equalToConstant: 40),
            postContentLabel.widthAnchor.constraint(equalTo: seperatorImageView.widthAnchor),
            postContentLabel.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            optionStackView.topAnchor.constraint(equalTo: postContentLabel.bottomAnchor, constant: 6),
            optionStackView.heightAnchor.constraint(equalTo: uniqueContainerView.heightAnchor, multiplier: 0.6),
            optionStackView.widthAnchor.constraint(equalTo: seperatorImageView.widthAnchor),
            optionStackView.centerXAnchor.constraint(equalTo: uniqueContainerView.centerXAnchor),
            
            totalVotesLabel.topAnchor.constraint(equalTo: optionStackView.bottomAnchor, constant: 10),
            totalVotesLabel.heightAnchor.constraint(equalToConstant: 18),
            totalVotesLabel.widthAnchor.constraint(equalTo: seperatorImageView.widthAnchor),
            totalVotesLabel.leadingAnchor.constraint(equalTo: optionStackView.leadingAnchor),
        ])
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
    
    private func createVoteButton(to imageView: UIImageView) {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        button.addTarget(self, action: #selector(voteButtonTapped), for: .touchUpInside)
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
    
    // Configuring cell with post data
    func configure(with post: Post) {
        userImageView.image = post.user.image
        userNameLabel.text = post.user.username
        timeAgoLabel.text = postContentSinceToday(post.createdAt)
        timeAgoLabel.textColor = .lightGray
        optionsImageView.image = UIImage(named: "optionsIcon")
        seperatorImageView.image = UIImage(named: "Seperator")
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
    @objc private func voteButtonTapped() {
        print("voteButton tapped")
    }
}


// hand.thumbsup
