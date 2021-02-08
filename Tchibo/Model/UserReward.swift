//
//  UserReward.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/23/21.
//

import Foundation

struct UserReward {
    let referralCode: String
    var referralCount: Int
    var giftCount: Float
    var postStreak: Int
    
    static let sampleUserReward = UserReward(
                                    referralCode: "xW482B32a",
                                    referralCount: 0,
                                    giftCount: 0,
                                    postStreak: 3
        )
}
