//
//  OrderViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/6/21.
//

import Foundation
import Firebase



class OrderViewModel: ObservableObject {
    @Published var availableGiftOrderItems: [OrderItem] = []
    @Published var currentBasketOrderItems: [OrderItem] = [.sampleUserOrderItem]
    @Published var orderTotal: Float = 0
    @Published var credit: Float = 0
    @Published var grandTotal: Float = 0
    
    init() {
        fetchGifts()
        // Calculate order total
        fetchOrders()
        getCredit()
    }
    
    func getCredit() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User must be signed in!")
            return
        }
        
        Firestore.firestore().collection("UserRewards").document(userID).addSnapshotListener { (snapshot, error) in
            if let data = snapshot?.data() {
                if let credit = data["credit"] as? Float {
                    DispatchQueue.main.async {
                        self.credit = Float(credit)
                    }
                }
            }
        }
    }
    
    func addToCurrentBasket(_ orderItem: OrderItem) {
        availableGiftOrderItems.removeAll { $0.id == orderItem.id }
        print(availableGiftOrderItems)
        
        currentBasketOrderItems.append(orderItem)
    }
    
    
    func fetchOrders() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User must be signed in!")
            return
        }
        
        Firestore.firestore().collection("Orders").document(userID).collection("Active").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching active order: \(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                snapshot.documentChanges.forEach {
                    if $0.type == .added {
                        let data = $0.document.data()
                        if let productID = data["product_id"] as? Int,
                           let senderID = data["sender_id"] as? String {
                            print(productID)
                            
                            fetchProduct(withProductID: String(productID)) { (product) in
                                guard let product = product else {
                                    print("Could not fetch product from productID.")
                                    return
                                }
                                fetchUserProfile(uid: senderID) { (userProfile) in
                                    guard let userProfile = userProfile else {
                                        print("Could not get user profile for order providerd")
                                        return
                                    }
                                    let newOrderItem = OrderItem(creator: userProfile,
                                                                 product: product,
                                                                 quantity: 1,
                                                                 giftID: nil)
                                    newOrderItem.product.fetchDefaultImage()
                                    
                                    DispatchQueue.main.async {
                                        self.orderTotal += newOrderItem.totalPrice
                                        self.currentBasketOrderItems.append(newOrderItem)
                                        
                                        self.grandTotal = self.orderTotal - self.credit
                                        
                                    }
                                }
                            }
                        }
                        else {
                            print("Could not get productID for gift.")
                            return
                        }
                            
                        
                    }
                }
                
            }
        }
    }
    
    
    func fetchGifts() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User must be signed in!")
            return
        }
        
        Firestore.firestore().collection("Gifts").document(userID).collection("/Received").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching gifts received by current user: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                snapshot.documentChanges.forEach {
                    if $0.type == .added {
                        let data = $0.document.data()
                        if let productID = data["product_id"] as? Int,
                           let senderID = data["sender_id"] as? String,
                           let giftID = data["gift_id"] as? String {
                            print(productID)
                            
                            fetchProduct(withProductID: String(productID)) { (product) in
                                guard let product = product else {
                                    print("Could not fetch product from productID.")
                                    return
                                }
                                fetchUserProfile(uid: senderID) { (userProfile) in
                                    guard let userProfile = userProfile else {
                                        print("Could not get user profile for gift provider.")
                                        return
                                    }
                                    let newOrderItem = OrderItem(creator: userProfile,
                                                                 product: product,
                                                                 quantity: 1,
                                                                 giftID: giftID)
                                    self.availableGiftOrderItems.append(newOrderItem)
                                }
                            }
                        }
                        else {
                            print("Could not get productID for gift.")
                            return
                        }
                            
                        
                    }
                }
            }
        }
        
    }
    
    
}
