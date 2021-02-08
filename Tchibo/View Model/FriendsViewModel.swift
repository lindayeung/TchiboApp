//
//  FriendsViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/1/21.
//

import Foundation
import AlgoliaSearchClient
import Firebase

class FriendsViewModel: ObservableObject {
    // Secure this in the DB
    let client = AlgoliaSearchClient.SearchClient(appID: "0AA5HP563B", apiKey: "a010a869062a9bfaeac94c0c613d81d1")
    let index: Index
    @Published var allUsers: [UserProfile] = []
    @Published var friends: [UserProfile] = []
    @Published var visibleFriends: [UserProfile] = []
    var searchQuery: String = "" { willSet { searchFriends(withSubstring: newValue )}}
    
    init() {
        index = client.index(withName: "users")
        fetchFriends()
    }
    
    func searchFriends(withSubstring substring: String) {
        if substring.isEmpty {
            visibleFriends = friends
            return
        }
        
        visibleFriends = friends.filter{ $0.firstName.contains(substring) ||
            $0.lastName.contains(substring) ||
            $0.username.contains(substring) ||
            ($0.firstName+$0.lastName).contains(substring.replacingOccurrences(of: " ", with: ""))
            
        }
    }
    
    func fetchFriends() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Current user must be signed in.")
            return
        }
        
        Firestore.firestore().collection("Friends").document(currentUser.uid).addSnapshotListener { (snapshot, err) in
            if let document = snapshot?.data(), let friends_uid = document["friends"] as? [String] {
                friends_uid.forEach { friend_uid in
                    fetchUserProfile(uid: friend_uid) { friend in
                        if let friend = friend {
                            DispatchQueue.main.async {
                                self.friends.append(friend)
                                if !self.visibleFriends.contains(where: {
                                    $0.uid == friend.uid
                                }) {
                                    self.visibleFriends.append(friend)
                                }
                            }
                        }
                        else {
                            print("Error getting friend from uid")
                        }
                    }
                }
            }
        }
    }
    
    func addFriend(_ friend: UserProfile) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Current user must be signed in.")
            return
        }
        
        
        Firestore.firestore().collection("Friends").document(currentUser.uid).updateData(["friends": FieldValue.arrayUnion([friend.uid])]) { err in
            if err != nil {
                // add document
                Firestore.firestore().collection("Friends").document(currentUser.uid).setData(["friends": [friend.uid]]) { err in
                    if let err = err {
                       print("Error sending friend request: No document to update: \(err)")
                    }
                }
                return
            }
        }
    }
    
    func searchAllUsers(withSubstring substring: String) {
        let query = Query(stringLiteral: substring)
        
        index.search(query: query) { result in
          switch result {
          case .failure(let error):
            print("Error: \(error)")
          case .success(let response):
            do {
                let hits: [UserProfile] = try response.extractHits()
                print("Search hits: \(hits)")
                DispatchQueue.main.async {
                    self.allUsers = hits
                }
            } catch let error {
                print("Hits decoding error :\(error)")
            }
          }
        }
    }
}
