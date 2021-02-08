//
//  GiftTransactionPostView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import SwiftUI
import Firebase

struct GiftTransactionPostView: View {
    var gift: Gift
    @State var showUserProfile: Bool = false
    
    let bounds = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        HStack(alignment: .center, spacing: 10) {
                            // Set as the current authenticated user's profile Image
                            CircularProfileImageView(uiImage: gift.sender.profileImage()!, size: 50)
                            Image(systemName: "arrow.right")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 10, alignment: .leading)
                            CircularProfileImageView(uiImage: gift.recipient.profileImage()!, size: 50)
                            
                            
                        }
                        .padding(.bottom)
                        Text(gift.timestamp.printAsTime())
                            .font(.custom(Styles.standardFontFamily, size: 16))
                            .padding(.leading, 10)
                            .foregroundColor(Color(Styles.primaryTextColor))
                    }
                    
                    Text("\(gift.sender.firstName) gifted \(gift.recipient.firstName) \(gift.productName).")
                        .fontWeight(.medium)
                        .font(.custom(Styles.standardFontFamily, size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.1101746932, green: 0.1102008447, blue: 0.1101712808, alpha: 1)))
                        .padding(.bottom, 10)
                    
                    HStack {
//                        Image(uiImage: gift.product.defaultImage!)
//                            .resizable()
//                            .frame(width: 100, height: 100, alignment: .leading)
                            
                        Text("\"" + gift.message + "\"")
                            .fontWeight(.light)
                            .font(.custom(Styles.standardFontFamily, size: 18))
                            .foregroundColor(Color(#colorLiteral(red: 0.1410083473, green: 0.1473487616, blue: 0.150567174, alpha: 1)))
                            .padding(.leading)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(Styles.mainColor2))
            )
            .padding(.bottom, 30)
            .onTapGesture {
                if gift.sender.uid != Auth.auth().currentUser?.uid {
                    showUserProfile = true
                }
            }
            .fullScreenCover(isPresented: $showUserProfile, content: {
                FriendProfileView(user: gift.sender, showUserProfileView: $showUserProfile)
            })
        }
        
    }
}


struct GiftTransactionPostView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
            GiftTransactionPostView(gift: .sampleGift)
        }
    }
}
