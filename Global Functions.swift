//
//  Global Functions.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation
import UIKit
import Firebase
import SwiftUI


func fetchUserProfile(uid: String, completion: @escaping (UserProfile?) ->()) {
    Firestore.firestore().collection("UserProfiles").document(uid).getDocument { document, error in
        if error != nil {
            print("Error getting user for uid: \(uid), error: \(error?.localizedDescription)")
            completion(nil)
            return
        }
        
        if let userData = document?.data() {
            if let uid = userData["uid"] as? String,
               let username = userData["username"] as? String,
               let firstName = userData["firstName"] as? String,
               let lastName = userData["lastName"] as? String,
               let birthday = userData["birthday"] as? Timestamp,
               let countryRawValue = userData["country"] as? String,
               let country = Country(rawValue: countryRawValue)
               {
                completion(UserProfile(objectID: uid, uid: uid, username: username, firstName: firstName, lastName: lastName,
                                       birthday: birthday.dateValue(), country: country, profileImageData: nil))
                
                // TODO: fetch user profile image
            }
            // handle unable to retrieve user data
        }
        else {
            print("Could not get user data for: \(uid).")
        }
        
    }
}

func fetchProduct(withProductID productID: String, completion: @escaping (Product?) ->()) {
    if let url = URL(string: "https://api.hackathon.tchibo.com/api/v1/products/\(productID)") {
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                print("Error fetching product: \(err.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    if let resp = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let productsData = resp["data"] as? [String : Any] {
                            
                                do {
                                    let productData =  try JSONDecoder().decode(ProductData.self, from: try JSONSerialization.data(withJSONObject: productsData, options: []))
                                    parseImageURLForProductWithData(productData, data: productsData)
                                    print(productData)
                                    
                                    completion(Product(data: productData))
                                    
                                }
                                catch  {
                                    print(error)
                                }
                            
                        }
                    }
                }
                catch {
                    print("Error decoding product: \(error)")
                }
            }
            else {
                print("No data")
            }
        }.resume()
    }
}

private func parseImageURLForProductWithData(_ product: ProductData, data: [String:Any]) {
    if let imageResp = data["image"] as? [String : Any] {
        if let defaultImageURL = URL(string: imageResp["default"] as! String) {
            product.defaultImageURL = defaultImageURL
        }
        var galleryImageURLs = [URL]()
        if let galleryResp = imageResp["gallery"] as? [String] {
            galleryResp.forEach {
                if let galleryImageURL = URL(string: $0) {
                    galleryImageURLs.append(galleryImageURL)
                }
            }
        }
        product.galleryImageURLs = galleryImageURLs
    }
}


func addProductToCurrentCart(product: Product, completion: @escaping () ->()) {
    guard let currentUserID = Auth.auth().currentUser?.uid else {
        print("User must be signed in!")
        return
    }
    
    let orderData: [String:Any] = ["product_id": product.data.id,
                                   "sender_id": currentUserID]
    
    Firestore.firestore().collection("Orders").document(currentUserID).collection("Active").addDocument(data: orderData) { error in
        if let error = error {
            print("Error adding order item to current cart: \(error.localizedDescription)")
            return
        }
        DispatchQueue.main.async {
            completion()
        }
    }
}






func fetchGiftsForUser(uid: String, completion: @escaping ([Gift]) ->()) {
    Firestore.firestore().collection("Gifts").document(uid).collection("Sent").getDocuments { (snapshot, error) in
        if let error = error {
            print("Could get gifts sent by uid \(uid): \(error)")
            return
        }
        
        if let documents = snapshot?.documents {
            var gifts = [Gift]()
            documents.forEach { document in
                let document = document.data()
                if let senderID = document["sender_id"] as? String, let recipientID = document["recipient_id"] as? String {
                    fetchUserProfile(uid: senderID) { sender in
                        guard sender != nil else {
                            print("Could not get sender for gift.")
                            return
                        }
                        
                        fetchUserProfile(uid: recipientID) { recipient in
                            guard recipient != nil else {
                                print("Could not get recipient for gift.")
                                return
                            }
                            
                            if let productName =  document["product_name"] as? String,
                               let productID = document["product_id"] as? Int,
                               let message = document["message"] as? String,
                               let timestamp = document["timestamp"] as? Timestamp {
                                let gift = Gift(sender: sender!,
                                                recipient: recipient!,
                                                productID: productID,
                                                productName: productName,
                                                message: message,
                                                timestamp: timestamp.dateValue())
                                gifts.append(gift)
                                
                                if gifts.count == documents.count {
                                    completion(gifts)
                                }
                            }
                        }
                    }
                }
                else {
                    print("Could not get users for gift.")
                }
            }
        }
    }
}

