//
//  GiftViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation
import Firebase

enum GiftStatus: String, Codable {
    case new, inCart, redeemed
}

class GiftViewModel: ObservableObject {
    
    @Published var recipient: UserProfile?
    @Published var product: Product?
    @Published var message = ""
    @Published var showSendGiftView: Bool = false
    @Published var showConfirmGiftPopover: Bool = false
    
    
    func sendGift(completion: @escaping  () -> ()) {
        guard Auth.auth().currentUser != nil else {
            // HANDLE PROMPT USER REGISTRATION/SIGN-IN
            print("User must be signed in to send gift!")
            return
        }
        guard recipient != nil, product != nil else {
            print("No recipient or product.")
            return
        }
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            let giftID = UUID().uuidString
            let giftData: [String:Any] = ["gift_id": giftID,
                                          "sender_id": currentUserID,
                                          "recipient_id": recipient!.uid,
                                          "product_id": product!.data.product_id, //product.id??
                                          "product_name": product!.data.title!,
                                          "message": message,
                                          "timestamp": Date(),
                                          "status": GiftStatus.new.rawValue
            ]
            
            
            print("sending \(product!.data.title!) to...\(recipient!.firstName)")
            
            // add a record under the sender's document
            Firestore.firestore().collection("Gifts/\(currentUserID)/Sent").document(giftID)
                .setData(giftData) { err in
                if let err = err {
                    print("Error adding gift for sender: \(err)")
                }
            }
            
            // update rewards
            let userRewardRef = Firestore.firestore().collection("UserRewards").document(currentUserID)
            userRewardRef.getDocument { (snapshot, error) in
                if let error = error {
                    print("error getting user rewards: \(error.localizedDescription)")
                    return
                }
                if let data = snapshot?.data() {
                    if let currentGiftCount = data["giftCount"] as? Float {
                        let newGiftCount = currentGiftCount + self.product!.data.price_amount!
                        if newGiftCount > 100 {
                            userRewardRef.updateData(["giftCount" : 0])
                            userRewardRef.setData(["credit": newGiftCount], merge: true)
                        }
                        else {
                            userRewardRef.updateData(["giftCount" : newGiftCount])
                        }
                    }
                }
            }
            
            // add a record under the recipient's document
            Firestore.firestore().collection("Gifts/\(recipient!.uid)/Received")
                .addDocument(data: giftData) { err in
                if let err = err {
                    print("Error adding gift for recipient: \(err)")
                }
                    // adding the gift as a post
                    let postID = UUID().uuidString
                    let postData: [String:Any] = ["post_id": postID,
                                                      "timestamp": Date(),
                                                      "creator": currentUserID,
                                                      "data": giftData,
                                                      "type": FeedItemType.giftPost.rawValue
                    ]
                    
                    
                    Firestore.firestore().collection("Posts").document(postID).setData(postData)
                    
                    // update the view to show the new gift
                    fetchGiftsForUser(uid: currentUserID) { (gifts) in
                        print(gifts)
                        self.message = ""
                        self.showSendGiftView = false
                        self.showConfirmGiftPopover = false
                        completion()
                    }
            }

        }
    }
}
