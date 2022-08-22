//
//  Posts.swift
//  PostsDisplay
//
//  Created by Alex Provarenko on 21.07.2022.
//

import Foundation
import UIKit

struct AllPostsResponse: Codable {
    let posts: [PostMain]
}

struct PostMain: Codable {
    let postID, timeshamp: Int
    let title, previewText: String
    let likesCount: Int
    
    var curentDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeshamp))
        let relativeDate = RelativeDateTimeFormatter()
        relativeDate.unitsStyle = .short
        return relativeDate.localizedString(for: date, relativeTo: Date())
    
    }
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title
        case previewText = "preview_text"
        case likesCount = "likes_count"

    }
}

struct PostDetailsResponse: Codable {
    let post: PostId
}

struct PostId: Codable {
    let postID, timeshamp: Int
    let title, text: String
    let postImage: String
    let likesCount: Int
    
    var curentDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeshamp))
        let relativeDate = RelativeDateTimeFormatter()
        relativeDate.unitsStyle = .short
        return relativeDate.localizedString(for: date, relativeTo: Date())
    }
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title, text, postImage
        case likesCount = "likes_count"
    }
}

