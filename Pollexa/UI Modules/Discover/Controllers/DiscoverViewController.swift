//
//  DiscoverViewController.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Properties
    private let provider = PostProvider.shared
    private let viewModel: PollViewModel
    
    // Lazy initialization for optimal memory usage
    lazy var avatarAndControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fill
        stackView.alignment = .center
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar_1")
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 17
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        let controlImageView = UIImageView()
        controlImageView.image = UIImage(systemName: "plus")
        controlImageView.tintColor = #colorLiteral(red: 0.3468087614, green: 0.3369399607, blue: 0.8411970139, alpha: 1)
        controlImageView.contentMode = .scaleAspectFit
        controlImageView.translatesAutoresizingMaskIntoConstraints = false
        controlImageView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        controlImageView.widthAnchor.constraint(equalToConstant: 23).isActive = true
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(controlImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var discoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activePollLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.3468087614, green: 0.3369399607, blue: 0.8411970139, alpha: 1)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.heightAnchor.constraint(equalToConstant: 78).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PollCollectionViewCell.self, forCellWithReuseIdentifier: "PollCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    // MARK: - Initializer.
    init(viewModel: PollViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupLayout()
    }
    // Binding ViewModel updates to the ViewController
    fileprivate func setupBindings() {
        viewModel.onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.postsCollectionView.reloadData()
            }
        }
    }
    // Autolayout confgs.
    private func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0.972548306, green: 0.9725496173, blue: 1, alpha: 1)
        view.addSubview(avatarAndControlStackView)
        view.addSubview(discoverLabel)
        view.addSubview(activePollLabel)
        view.addSubview(postsCollectionView)

        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            avatarAndControlStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -24),
            avatarAndControlStackView.heightAnchor.constraint(equalToConstant: 44),
            avatarAndControlStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarAndControlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarAndControlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            discoverLabel.topAnchor.constraint(equalTo: avatarAndControlStackView.bottomAnchor, constant: 4),
            discoverLabel.leadingAnchor.constraint(equalTo: avatarAndControlStackView.leadingAnchor),
            discoverLabel.heightAnchor.constraint(equalToConstant: 36),
            discoverLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            activePollLabel.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor, constant: 24),
            activePollLabel.heightAnchor.constraint(equalToConstant: 78),
            activePollLabel.widthAnchor.constraint(equalTo: postsCollectionView.widthAnchor, multiplier: 0.95),
            activePollLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            postsCollectionView.topAnchor.constraint(equalTo: activePollLabel.bottomAnchor, constant: 8),
            postsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 4.5/6),
            postsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            postsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionView protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollCollectionViewCell", for: indexPath) as? PollCollectionViewCell else {
            return UICollectionViewCell()
        }
        let post = viewModel.post(at: indexPath.item)
        cell.configure(with: post)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: postsCollectionView.bounds.width, height: 400)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
}
