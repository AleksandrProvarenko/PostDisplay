//
//  APICaller.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 21.07.2022.
//

import Foundation
import UIKit

struct Constants {
    static let url = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getMainPosts(completin: @escaping (Result<[PostMain], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.url)/main.json") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(AllPostsResponse.self, from: data)
                completin(.success(results.posts))
            } catch {
                completin(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getId(id: Int, completin: @escaping (Result<PostId, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.url)/posts/\(id).json") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(PostDetailsResponse.self, from: data)
                completin(.success(results.post))
            } catch {
                completin(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
}
