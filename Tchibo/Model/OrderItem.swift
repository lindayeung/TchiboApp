//
//  OrderItem.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/8/21.
//

import Foundation
import UIKit

struct OrderItem: Identifiable {
    let creator: UserProfile
    let product: Product
    let quantity: Int
    var totalPrice: Float { product.data.price_amount! * Float(quantity) }
    let giftID: String?
    var id = UUID().uuidString
    
    static let sampleGiftOrderItem = OrderItem(creator: UserProfile.sampleUser,
                                           product: Product.sampleProduct,
                                           quantity: 1,
                                           giftID: UUID().uuidString)
    static let sampleGiftOrderItem2 = OrderItem(creator: UserProfile.sampleUser,
                                           product: Product.sampleProduct,
                                           quantity: 1,
                                           giftID: UUID().uuidString)
    static let sampleGiftOrderItem3 = OrderItem(creator: UserProfile.sampleUser,
                                           product: Product.sampleProduct,
                                           quantity: 1,
                                           giftID: UUID().uuidString)
    
    static let sampleUserOrderItem = OrderItem(creator: .sampleUser,
                                               product: .sampleProduct,
                                               quantity: 1,
                                               giftID: nil)
    
}
