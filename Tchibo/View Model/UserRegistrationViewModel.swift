//
//  UserRegistrationViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/13/21.
//

import Foundation
import Firebase
import FirebaseAuth
import CryptoKit
import AlgoliaSearchClient


class UserRegistrationViewModel: ObservableObject {
    @Published var referralCode = ""
    @Published var validReferralCode = false
    private var referrerID: String?
    
    let userProfileRef = Firestore.firestore().collection("UserProfiles")
    let userRewardRef = Firestore.firestore().collection("UserRewards")
    
    func addUserToUserSearch(_ user: UserProfile) {
        
        let index = AlgoliaSearchClient.SearchClient(appID: "0AA5HP563B", apiKey: "4dcf864445f83ff46f0c31a10aff0f2f").index(withName: "users")
        
        index.saveObject(user) { result in
            print(result)
            if case .success(let response) = result {
                print("Response: \(response)")
            }
        }
    }
    
    
    func checkReferralCode() {
        Firestore.firestore().collection("Referrals").document(referralCode).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching referral user or referral code does not exist: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.validReferralCode = false
                }
                return
            }
            if let data = snapshot?.data(), let userID = data["user_id"] as? String {
                self.referrerID = userID
                DispatchQueue.main.async {
                    self.validReferralCode = true
                }
            }
            else {
                DispatchQueue.main.async {
                    self.validReferralCode = false
                }
            }
        }
    }
    
    
    func addUserToDatabase(email: String, phoneNumber: String,
                           firstName: String, lastName: String,
                           birthday: Date, country: Country,
                           username: String, password: String) {
        
        
//        let passwordData = Data(password.utf8)
//        let passwordHash = SHA256.hash(data: passwordData).compactMap { String(format: "%02x", $0) }.joined()
        
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            // CHECK UNIQUE USERNAME
            if let error = error {
                print("Error creating new user: \(error)")
            }
            
            else {
                if let result = result {
                    let user_uid = result.user.uid
                    
                    let userProfileData: [String: Any] =  [
                        "uid" : user_uid,
                        "username": username,
                        "firstName" : firstName,
                        "lastName" : lastName,
                        "birthday" : birthday,
                        "country" : country.rawValue,
                    ]
                    
                    let referralCode = randomAlphaNumericString(length: 8)
                    let userReward: [String: Any] = [
                        "referralCode" : referralCode,
                        "referralCount": 0,
                        "giftCount" : 0,
                    ]
                    
                    self.userProfileRef.document(user_uid).setData(userProfileData) { (error) in
                        if let error = error {
                            // Error handling for user profile creation
                            print("Error creating new user: \(error)")
                            return
                        }
                        
                        self.addUserToUserSearch(UserProfile(objectID: user_uid,
                                                             uid: user_uid,
                                                             username: username,
                                                             firstName: firstName,
                                                             lastName: lastName,
                                                             birthday: birthday,
                                                             country: country,
                                                             profileImageData: nil))
                        
                        self.userRewardRef.document(user_uid).setData(userReward) { error in
                            if let error = error {
                                // Error handling for user reward uploading
                                print("Error creating new user rewards: \(error.localizedDescription)")
                                return
                            }
                            
                            
                            // Set referrals collection
                            Firestore.firestore().collection("Referrals").document(referralCode).setData(["user_id": user_uid]) { error in
                                if let error = error {
                                    print("Error creating referral code to user reference: \(error.localizedDescription)")
                                    return
                                }
                                
                                if let referrerID = self.referrerID {
                                    Firestore.firestore().collection("UserRewards").document(referrerID).updateData(["referralCount": FieldValue.increment(Int64(1))]) { error in
                                        if let error = error {
                                            print("Error incrementing referrer's referral count: \(error.localizedDescription)")
                                            return
                                        }
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        
                                    }
                                }
                                else {
                                    print(userProfileData)
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                }
                            }
                            
                           
                        }
                    }
                }
                
                
            }
        }
        
        
        func randomAlphaNumericString(length: Int) -> String {
            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let allowedCharsCount = UInt32(allowedChars.count)
            var randomString = ""

            for _ in 0 ..< length {
                let randomNum = Int(arc4random_uniform(allowedCharsCount))
                let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
                let newCharacter = allowedChars[randomIndex]
                randomString += String(newCharacter)
            }

            return randomString
        }

    }
    

                    
    
}
