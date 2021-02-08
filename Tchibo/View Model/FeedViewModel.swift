//
//  FeedViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/23/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FeedViewModel: ObservableObject {
    @Published var globalPosts: [FeedItem] = []
    @Published var friendPosts: [FeedItem] = []
    @Published var userPosts: [FeedItem] = []
    @Published var isUploadingPost = false
    

    
    init() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not currently logged in.")
            return
        }

        fetchFeedForTab(.global)
        fetchFeedForTab(.friends)
        fetchFeedForTab(.me)
    }
    
    
    private func fetchFeedForTab(_ feedTab: FeedTab) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not currently logged in.")
            return
        }
        var uidValues: [String] = []
        
        if feedTab == .global {
            Firestore.firestore().collection("Posts").order(by: "timestamp").addSnapshotListener { (snapshot, error) in
                guard error == nil else {
                    print("Could not fetch posts for global feed.")
                    return
                }
                guard let snapshot = snapshot else {
                    print("Could not fetch posts for global feed.")
                    return
                }
                self.handlePostSnapshot(snapshot: snapshot, forFeedTab: .global)
            }
        }
        
        else if feedTab == .friends {
            var friends: [String] = []
            
            Firestore.firestore().collection("Friends").document(currentUserID).getDocument { (snapshot, err) in
                if let document = snapshot?.data(), let friends_uid = document["friends"] as? [String] {
                    friends_uid.forEach { friend_uid in
                        friends.append(friend_uid)
                    }
                }
                if friends.isEmpty {
                    return
                }
                
                Firestore.firestore().collection("Posts").whereField("creator", in: friends).order(by: "timestamp").addSnapshotListener { (snapshot, error) in
                    guard error == nil else {
                        print("Could not fetch posts for friend feed.")
                        return
                    }
                    guard let snapshot = snapshot else {
                        print("Could not fetch posts for friend feed.")
                        return
                    }
                    self.handlePostSnapshot(snapshot: snapshot, forFeedTab: .friends)
                }
            }
        }
        
        else if feedTab == .me {
            Firestore.firestore().collection("Posts").whereField("creator", isEqualTo: currentUserID).order(by: "timestamp").addSnapshotListener { (snapshot, error) in
                guard error == nil else {
                    print("Error fetching posts for user feed: \(error!.localizedDescription)")
                    return
                }
                guard let snapshot = snapshot else {
                    print("Could not fetch posts for user feed.")
                    return
                }
                self.handlePostSnapshot(snapshot: snapshot, forFeedTab: .me)
            }
        }
        
        
        
        
    }
    
    private func handlePostSnapshot(snapshot: QuerySnapshot, forFeedTab feedTab: FeedTab) {
        snapshot.documentChanges.forEach { documentChange in
            if documentChange.type == .added {
                let postData = documentChange.document.data()
                
                if let feedItemType = postData["type"] as? String, feedItemType == FeedItemType.customPost.rawValue {
                    self.parseCustomPostFor(postData: postData, forFeedTab: feedTab)
                }
                if let feedItemType = postData["type"] as? String, feedItemType == FeedItemType.giftPost.rawValue {
                    self.parseGiftPostFor(postData: postData, forFeedTab: feedTab)
                }
                
            }
            else if documentChange.type == .modified {
                return
            }
        }
    }
    
    private func parseCustomPostFor(postData: [String:Any], forFeedTab feedTab: FeedTab) {
        if let user_id = postData["creator"] as? String {
            fetchUserProfile(uid: user_id) { userProfile in
                guard userProfile != nil else {
                    print("Could not get user for uid: \(user_id)")
                    return
                }
                if let customPostData = postData["data"] as? [String:Any],
                   let timestamp = postData["timestamp"] as? Timestamp {
                    if let text = customPostData["text"] as? String {
                        let newPost = CustomPost(id: user_id,
                                                 user: userProfile!,
                                                 text: text,
                                                 timestamp: timestamp.dateValue())
                        
                        DispatchQueue.main.async {
                            if feedTab == .global {
                                self.globalPosts.append(newPost)
                            }
                            else if feedTab == .friends {
                                self.friendPosts.append(newPost)
                            }
                            else {
                                self.userPosts.append(newPost)
                            }
                        }
                        
                        if let imageURLString = customPostData["imageURL"] as? String, let imageURL = URL(string: imageURLString) {
                            newPost.imageURL = imageURL
                            
                            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                                // print("fetching image for post: \(newPost.text)...")
                                if error != nil {
                                    print("Could not get image for postID: \(newPost.id), error: \(error!.localizedDescription)")
                                    return
                                }
                                // convert data back into image
                                if let data = data, let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        // set the post's image
                                        // print("setting image for post: \(newPost.text)...")
                                        newPost.image = image
                                    }
                                }
                            }.resume()
                        }
                    }
                }
            }
        }
    }
    
    
    
    private func parseGiftPostFor(postData: [String:Any], forFeedTab feedTab: FeedTab) {
        if let giftData = postData["data"] as? [String:Any], let timestamp = postData["timestamp"] as? Timestamp,
           let postID = postData["post_id"] as? String {
            if let senderID = giftData["sender_id"] as? String,
               let recipientID = giftData["recipient_id"] as? String {
                fetchUserProfile(uid: senderID) { sender in
                    guard let sender = sender else {
                        print("Could not get sender for gift.")
                        return
                    }
                    
                    fetchUserProfile(uid: recipientID) { recipient in
                        guard let recipient = recipient else {
                            print("Could not get recipient for gift.")
                            return
                        }
                        if let productName =  giftData["product_name"] as? String,
                           let productID = giftData["product_id"] as? Int,
                           let message = giftData["message"] as? String {
                            let newPost = GiftPost(postID: postID,
                                                    feedItemType: .giftPost,
                                                    sender: sender,
                                                    recipient: recipient,
                                                    productID: productID,
                                                    productName: productName,
                                                    message: message,
                                                    timestamp: timestamp.dateValue())
                            
                            DispatchQueue.main.async {
                                if feedTab == .global {
                                    self.globalPosts.append(newPost)
                                }
                                else if feedTab == .friends {
                                    self.friendPosts.append(newPost)
                                }
                                else {
                                    self.userPosts.append(newPost)
                                }
                            }
                        }
                        else {
                            print("Could not parse gift.")
                        }
                        
                    }
                }
            }
            else {
                print("Could not get senderID or recipientID.")
            }
        }
    }
    
    
    
    func createPost(newPostText: String, newPostImage: UIImage?, completion: @escaping () -> ()) {
        isUploadingPost = true
        let postID = UUID().uuidString
        
        if newPostImage == nil {
            uploadPost(text: newPostText, forPostID: postID, completion: completion)
        }
        else {
            uploadPostWithImage(image: newPostImage!, text: newPostText, forPostID: postID, completion: completion)
        }
    }
    
    func uploadPost(text: String, forPostID postID: String, completion: @escaping () -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not currently logged in.")
            return
        }
        
        let customPostData: [String: Any] = [
            "id": postID,
            "user_id": Auth.auth().currentUser!.uid,
            "text": text,
            "timestamp": Date()
        ]
        
        let postData: [String:Any] = ["post_id": postID,
                                      "timestamp": Date(),
                                      "creator": currentUserID,
                                      "data": customPostData,
                                      "type": FeedItemType.customPost.rawValue
        ]
        
        
        Firestore.firestore().collection("Posts").document(postID).setData(postData, merge: false) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func uploadPostWithImage(image: UIImage, text: String, forPostID postID: String, completion: @escaping () -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not currently logged in.")
            return
        }
        
        let imageID = UUID().uuidString
        let postImagesRef = Storage.storage().reference().child("PostImages")
        
        if let imageData = image.jpegData(compressionQuality: 0.75) {
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageRef = postImagesRef.child("\(postID)/\(imageID)")
            
            // put image in firebase storage
            imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                // get url for the location in storage
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Could not retrieve URL for image error: \(error.localizedDescription)")
                        return
                    }
                    
                    // upload post data with a url reference to the image's location in firebase storage
                    if let url = url {
                        let customPostData: [String: Any] = [
                            "id": postID,
                            "user_id": Auth.auth().currentUser!.uid,
                            "text": text,
                            "timestamp": Date(),
                            "imageURL": url.absoluteString
                        ]
                        
                        let postData: [String:Any] = ["post_id": postID,
                                                      "timestamp": Date(),
                                                      "creator": currentUserID,
                                                      "data": customPostData,
                                                      "type": FeedItemType.customPost.rawValue
                        ]
                        
                        Firestore.firestore().collection("Posts").document(postID).setData(postData, merge: false) { (error) in
                            if error != nil {
                                print("Error uploading post: \(error!.localizedDescription)")
                                return
                            }
                            
                            let userRewardsRef = Firestore.firestore().collection("UserRewards").document(currentUserID)
                            userRewardsRef.getDocument { (snapshot, error) in
                                if let error = error {
                                    print("Error getting user rewards: \(error.localizedDescription)")
                                    return
                                }
                                if let data = snapshot?.data(), let latestPostTimestamp = data["latest_post_timestamp"] as? Timestamp {
                                    if Calendar.current.isDateInYesterday(latestPostTimestamp.dateValue()) {
                                        if let currentPostStreak = data["post_streak"] as? Int {
                                            let newPostStreak = currentPostStreak + 1
                                            
                                            if newPostStreak >= 7 {
                                                userRewardsRef.updateData(["credit": FieldValue.increment(Int64(5)),
                                                                           "post_streak": 1
                                                ])
                                            
                                            }
                                            else {
                                                userRewardsRef.setData(["post_streak": FieldValue.increment(Int64(1))],
                                                                       merge: true) { error in
                                                    if let error = error {
                                                        print("Error updating post streak: \(error.localizedDescription)")
                                                        return
                                                    }
                                                }
                                            }
                                        }
                                        else {
                                            userRewardsRef.setData(["post_streak": 1], merge: true)
                                        }
                                    }
                                    else if !Calendar.current.isDateInToday(latestPostTimestamp.dateValue()) {
                                        userRewardsRef.setData(["post_streak": 1], merge: true)
                                    }
                                }
                                else {
                                    userRewardsRef.setData(["post_streak": 1], merge: true)
                                }
                                userRewardsRef.setData(["latest_post_timestamp" : Date()], merge: true) { error in
                                    if let error = error {
                                        print("Error setting timestamp: \(error.localizedDescription)")
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        completion()
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}
