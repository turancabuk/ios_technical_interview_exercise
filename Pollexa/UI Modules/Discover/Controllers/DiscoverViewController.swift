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
    lazy var postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PollCollectionViewCell.self, forCellWithReuseIdentifier: "PollCollectionViewCell")
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
        view.backgroundColor = .white
        view.addSubview(postsCollectionView)
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            postsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            postsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 4/5),
            postsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            postsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
}
