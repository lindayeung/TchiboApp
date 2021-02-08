//
//  Post.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/21/21.
//

import Foundation
import UIKit

class CustomPost: Identifiable, ObservableObject, FeedItem {
    var postID: String = UUID().uuidString
    var feedItemType: FeedItemType = .customPost
    let id: String
    @Published var user: UserProfile
    var text: String?
    @Published var image: UIImage?
    var imageURL: URL?
    var timestamp: Date
    
    init(id: String, user: UserProfile, text: String, image: UIImage?, imageURL: URL?, timestamp: Date) {
        self.id = id
        self.user = user
        self.text = text
        self.image = image
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
    
    init(id: String, user: UserProfile, text: String, timestamp: Date) {
        self.id = id
        self.user = user
        self.text = text
        self.timestamp = timestamp
    }
    
    static let samplePost = CustomPost(id: "1", user: UserProfile.sampleUser, text: "I really need some caffeine right now.", timestamp: Date())
    static let samplePostWithImage = CustomPost(id: "1", user: UserProfile.sampleUser, text: "I feel dead.", image: UIImage(named: "Coffee"), imageURL: nil, timestamp: Date())
    
    var description: String {
        return """
                    id: \(id)
                    user profile: \(user.description)"
                    text: \(text)
                    timestamp: \(timestamp)
                    imageURL: \(imageURL)
                """
    }
}


