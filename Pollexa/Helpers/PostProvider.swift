//
//  PostProvider.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import Foundation

protocol PostProviderProtocol {
    func fetchAll(completion: @escaping (Result<[Post], Error>) -> Void)
}
class PostProvider: PostProviderProtocol {
    
    // MARK: - Properties
    static let shared: PostProviderProtocol = PostProvider(fileName: "posts")
    private let filename: String
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    // MARK: - Life Cycle
    private init(fileName: String) {
        self.filename = fileName
    }
    
    // MARK: - Methods
    func fetchAll(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let fileUrl = Bundle.main.url(
            forResource: filename,
            withExtension: "json"
        ) else {
            completion(.failure(
                NSError(
                    domain: "JSON file not found.",
                    code: 0,
                    userInfo: nil
                )
            ))
            return
        }
        
        guard let postData = try? Data.init(contentsOf: fileUrl) else {
            completion(.failure(
                NSError(
                    domain: "Could not read the data.",
                    code: 1,
                    userInfo: nil
                )
            ))
            return
        }
        
        do {
            let posts = try decoder.decode([Post].self, from: postData)
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
    }
}
