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
    lazy var timeAgoLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 12), numOfLines: 1)
    lazy var postContentLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 14), numOfLines: 0)
    lazy var optionImageView = createCustomImageView(cornerRadius: 12)
    lazy var optionImageView1 = createCustomImageView(cornerRadius: 12)
    lazy var totalVotesLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 12), numOfLines: 1)
    
    lazy var userInfoStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .horizontal, spacing: 8)
        stackView.alignment = .center
        let userImageAndTimeStackView = createCustomStackView(axis: .vertical, spacing: 4)
        userImageAndTimeStackView.addArrangedSubview(userNameLabel)
        userImageAndTimeStackView.addArrangedSubview(timeAgoLabel)
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(userImageAndTimeStackView)
        return stackView
    }()
    
    lazy var optionStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .horizontal, spacing: 8)
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(optionImageView)
        stackView.addArrangedSubview(optionImageView1)
        return stackView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = createCustomStackView(axis: .vertical, spacing: 8)
        stackView.addArrangedSubview(userInfoStackView)
        stackView.addArrangedSubview(postContentLabel)
        stackView.addArrangedSubview(optionStackView)
        stackView.addArrangedSubview(totalVotesLabel)
        return stackView
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
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 40),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    // MARK: - Factory UI Methods.
    private func createCustomImageView(cornerRadius: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
    // Configuring cell with post data
    func configure(with post: Post) {
        userImageView.image = post.user.image
        userNameLabel.text = post.user.username
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        timeAgoLabel.text = dateFormatter.string(from: post.createdAt)
        postContentLabel.text = post.content
        
        if post.options.count > 0 {
            optionImageView.image = post.options[0].image
        }
        
        if post.options.count > 1 {
            optionImageView1.image = post.options[1].image
        }
        
        totalVotesLabel.text = "Total Votes: \(post.options.count)"
    }
}
