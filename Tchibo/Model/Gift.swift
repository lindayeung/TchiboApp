//
//  Gift.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation
import UIKit

struct Gift {
    let gift_id: String = UUID().uuidString
    let sender: UserProfile
    let recipient: UserProfile
    let productID: Int
    let productName: String
    var message: String
    let timestamp: Date

    
    static let sampleGift = Gift(sender: .sampleUser,
                                 recipient: .sampleUser,
                                 productID: Product.sampleProduct.data.product_id!,
                                 productName: Product.sampleProduct.data.title!,
                                 message: "Happy coffee!",
                                 timestamp: Date())
}


struct GiftPost: FeedItem {
    var postID: String = UUID().uuidString
    var feedItemType: FeedItemType = .giftPost
    let sender: UserProfile
    let recipient: UserProfile
    let productID: Int
    let productName: String
    var message: String
    let timestamp: Date
    
    func gift() -> Gift {
        Gift(sender: sender, recipient: recipient, productID: productID, productName: productName, message: message, timestamp: timestamp)
    }
    
    static let sampleGift = GiftPost(sender: .sampleUser,
                                     recipient: .sampleUser,
                                     productID: Product.sampleProduct.data.product_id!,
                                     productName: Product.sampleProduct.data.title!,
                                     message: "Happy Coffee!",
                                     timestamp: Date())
}


