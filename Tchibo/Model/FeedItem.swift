//
//  FeedItem.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation

enum FeedItemType: String, Codable {
    case customPost, giftPost
}

protocol FeedItem {
    var feedItemType: FeedItemType { get }
    var postID: String { get set }
    var timestamp: Date { get }
}
