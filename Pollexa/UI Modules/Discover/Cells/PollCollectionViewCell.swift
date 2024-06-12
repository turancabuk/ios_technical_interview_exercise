//
//  PollCollectionViewCell.swift
//  Pollexa
//
//  Created by Turan Çabuk on 5.06.2024.
//

import UIKit

protocol PollCollectionViewCellDelegate: AnyObject {
    func updateVoteStatus(for postId: String, with option: Int)
}
class PollCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: PollCollectionViewCellDelegate?
    var viewModel: PollCollectionViewModel? {
        didSet {
            viewModel?.delegate = self
            configureBindings()
        }
    }
    
    // MARK: - UI Elements
    // Properties has been created with lazy initialization for optimal memory usage.
    lazy var userImageView = createCustomImageView(cornerRadius: 20)
    lazy var userNameLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 16), numOfLines: 1)
    lazy var timeAgoLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 14), numOfLines: 1)
    lazy var optionsImageView = createCustomImageView(cornerRadius: 0)
    lazy var seperatorImageView = createCustomImageView(cornerRadius: 0)
    lazy var lastVotedLabel = createCustomLabel(font: UIFont.systemFont(ofSize: 14), numOfLines: 1)
    lazy var postContentLabel = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 14), numOfLines: 0)
    lazy var optionImageView = createCustomImageView(cornerRadius: 12)
    lazy var optionImageView1 = createCustomImageView(cornerRadius: 12)
    lazy var percentageLabel: UILabel = {
        let label = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 14), numOfLines: 1)
        label.accessibilityIdentifier = "percentageLabel"
        return label
    }()
    lazy var percentageLabel1: UILabel = {
        let label = createCustomLabel(font: UIFont.boldSystemFont(ofSize: 14), numOfLines: 1)
        label.accessibilityIdentifier = "percentageLabel1"
        return label
    }()
    lazy var totalVotesLabel: UILabel = {
        let label = createCustomLabel(font: UIFont.systemFont(ofSize: 12), numOfLines: 1)
        label.accessibilityIdentifier = "totalVotesLabel"
        return label
    }()

    
    // Stack views to organize the UI elements
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
    
    // MARK: - Inıtializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel?.stopTimer()
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
        
        // Define layout constraints
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
        button.accessibilityIdentifier = isFirstOption ? "voteButton1" : "voteButton2"
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
            label.heightAnchor.constraint(equalToConstant: 36),
            label.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Data Binding
    private func configureBindings() {
        viewModel?.onDataUpdated = { [weak self] in
            guard let self = self else {return}
            self.updateVoteUI()
        }
    }
    // Configuring cell with post data
    func configureCell(with post: Post, voteStatus: [String: (option: Int, date: Date)]) {
        viewModel?.configure(with: post, voteStatus: voteStatus)
    }
    
    @objc private func voteButtonTapped1() {
        viewModel?.vote(option: 1)
        if let postId = viewModel?.postId {
            delegate?.updateVoteStatus(for: postId, with: 1)
        }
    }
    
    @objc private func voteButtonTapped2() {
        viewModel?.vote(option: 2)
        if let postId = viewModel?.postId {
            delegate?.updateVoteStatus(for: postId, with: 2)
        }
    }
    
    // Helper Method
    func postContentSinceToday(_ date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        formatter.maximumUnitCount = 1
        let now = Date()
        let dateString = formatter.string(from: date, to: now) ?? ""
        return "\(dateString) ago"
    }
}
extension PollCollectionViewCell: PollViewModelDelegate {
    func updateVoteUI() {
        guard let viewModel = self.viewModel else {return}
        percentageLabel.text = "\(viewModel.getOptionPercentage(option: 1))%"
        percentageLabel1.text = "\(viewModel.getOptionPercentage(option: 2))%"
        totalVotesLabel.text = viewModel.getTotalVotesText()
        lastVotedLabel.text = viewModel.getLastVotedText()
        
        percentageLabel.isHidden = !viewModel.hasVoted
        percentageLabel1.isHidden = !viewModel.hasVoted
        
        optionImageView.subviews.compactMap {$0 as? UIButton}.forEach {$0.isHidden = viewModel.hasVoted}
        optionImageView1.subviews.compactMap {$0 as? UIButton}.forEach {$0.isHidden = viewModel.hasVoted}
        
        userNameLabel.text = viewModel.post?.user.username
        timeAgoLabel.text = postContentSinceToday(viewModel.post?.createdAt ?? Date())
        timeAgoLabel.textColor = .lightGray
        
        lastVotedLabel.textColor = .lightGray
        postContentLabel.text = viewModel.post?.content
        totalVotesLabel.textColor = .lightGray
        self.userImageView.image = viewModel.post?.user.image
        self.optionsImageView.image = UIImage(named: "optionsIcon") ?? UIImage(systemName: "circle.fill")
        self.seperatorImageView.image = UIImage(named: "Seperator") ?? UIImage(systemName: "circle.fill")
        if viewModel.post?.options.count ?? 0 > 0 {
            self.optionImageView.image = viewModel.post?.options[0].image
        }
        if viewModel.post?.options.count ?? 0 > 1 {
            self.optionImageView1.image = viewModel.post?.options[1].image
        }
    }
}
