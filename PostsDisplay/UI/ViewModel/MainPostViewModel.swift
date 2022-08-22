//
//  File.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 02.08.2022.
//

import Foundation


class MainPostViewModel {
    
    var posts: [PostMain] = []
    
    func mainPostsViewModel(completiom: @escaping() -> ()) {
        APICaller.shared.getMainPosts { results in
            switch results {
            case.success(let posts):
                self.posts = posts
                completiom()
            case.failure(let error):
                print(error)
               
            }
        }
    }
    
}
