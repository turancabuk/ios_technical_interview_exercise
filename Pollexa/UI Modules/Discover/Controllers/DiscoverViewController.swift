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
