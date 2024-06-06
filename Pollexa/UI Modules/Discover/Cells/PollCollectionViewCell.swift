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
    
    lazy var optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(optionImageView)
        stackView.addArrangedSubview(optionImageView1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
