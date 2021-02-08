//
//  User.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/20/21.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

struct UserProfile: Codable {
    
    var objectID: String
    let uid: String
    let username: String
    let firstName: String
    let lastName: String
    let birthday: Date
    let country: Country
    let profileImageData: Data?
    
    
    func profileImage() -> UIImage? {
        if let profileImageData = profileImageData {
            return UIImage(data: profileImageData)
        }
        return UIImage(named: "default_profile")
    }

    
    
    static var sampleUser = UserProfile(objectID: "1",
                                        uid: "1",
                                        username: "caffeine_addict",
                                        firstName: "Alice",
                                        lastName: "Morgan",
                                        birthday: Date(),
                                        country: .UnitedKingdom,
                                        profileImageData: nil)
    
    var description: String {
        return """
                uid: \(uid)
                username: \(username)
                first name: \(firstName)
                last name: \(lastName)
                birthday: \(birthday)
                country: \(country)
            """
    }
    
    
    
}

extension UserProfile {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        objectID = try values.decode(String.self, forKey: .uid)
        uid = try values.decode(String.self, forKey: .uid)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        
        // decoding birthday
        var birthdayString: String = ""
        birthdayString = try values.decode(String.self, forKey: .birthday)
        birthdayString = birthdayString.components(separatedBy: ".")[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        birthday = dateFormatter.date(from: birthdayString)!
        
        country = try values.decode(Country.self, forKey: .country)
        username = try values.decode(String.self, forKey: .username)
        profileImageData = nil
    }
}



