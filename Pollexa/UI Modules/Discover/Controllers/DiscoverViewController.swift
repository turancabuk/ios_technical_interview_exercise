//
//  DiscoverViewController.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Properties
    private let postProvider = PostProvider.shared
    private let viewModel: PollViewModel!
    
    // Lazy initialization for optimal memory usage
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PollCollectionViewCell.self, forCellWithReuseIdentifier: "PollCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    fileprivate func fetchData() {
        postProvider.fetchAll { result in
            switch result {
            case .success(let posts):
                print(posts)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollCollectionViewCell", for: indexPath) as? PollCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let viewModel {
            let post = viewModel.post(at: indexPath.row)
        }
    }
}
