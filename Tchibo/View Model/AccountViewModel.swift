//
//  AccountViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import Foundation
import Firebase

class AccountViewModel: ObservableObject {
    @Published var showAccountSettingsView: Bool = false
    
    @Published var currentUser: UserProfile? = .sampleUser
    @Published var userRewards: UserReward? = .sampleUserReward
    
    @Published var rewardPointPercentage: Float = 0
    @Published var postStreak: [String] = []
    
    init() {
        fetchCurrentUser()
        fetchRewards()
    }
    
    func updateUserProfile(editProfileImage: UIImage, editFirstName: String, editLastName: String, selectedCountryIndex: Int) {
        
        
    }
    
    private func fetchCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }
        
        fetchUserProfile(uid: currentUserID) { (userProfile) in
            guard let userProfile = userProfile else {
                print("Could not get user profile for the current logged in user uid!")
                return
            }
            self.currentUser = userProfile
        }
    }
    
    private func fetchRewards() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }
        
        Firestore.firestore().collection("UserRewards").document(currentUserID).addSnapshotListener() { (snapshot, err) in
            if let err = err {
                print("Error fetching user rewards: \(err.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data() {
                if let giftCount = data["giftCount"] as? Float,
                   let referralCode = data["referralCode"] as? String,
                   let referralCount = data["referralCount"] as? Int {
                    
                    
                    let postStreak = data["post_streak"] as? Int
                    self.userRewards = UserReward(referralCode: referralCode,
                                        referralCount: referralCount,
                                        giftCount: giftCount,
                                        postStreak: postStreak != nil ? postStreak! : 0)
                    print(self.userRewards)
                    if let postStreak = postStreak {
                        DispatchQueue.main.async {
                            self.postStreak = Array(repeating: "🔥", count: postStreak)
                        }
                    }
                }
                else {
                    print("Could not parse user rewards data.")
                    return
                }
                
            }
        }
    }
    
    
}
