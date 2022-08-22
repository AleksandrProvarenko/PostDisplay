//
//  IdPostViewModel.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 02.08.2022.
//

import Foundation
import UIKit

class IdPostViewModel {
    
   var post: PostId?
    
    func postIdViewModel(postId: Int, completion: @escaping(PostId) -> ()) {
        APICaller.shared.getId(id: postId) { result in
            switch result {
            case.success(let post):
                self.post = post
                completion(post)
            case.failure(let error):
                print(error)
            }
        }
    }
}
