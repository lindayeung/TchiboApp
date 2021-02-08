//
//  PostView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import SwiftUI
import Firebase

struct PostView: View {
    @StateObject var post: CustomPost
    var postDirection: PostDirection
    @State var showUserProfile: Bool = false
    
    let bounds = UIScreen.main.bounds
    
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            if postDirection == .left {
                CircularProfileImageView(uiImage: post.user.profileImage()!, size: 50)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        Text(post.user.firstName + " " + post.user.lastName)
                            .bold()
                        Text(post.timestamp.printAsTime())
                    }
                    .font(.custom(Styles.standardFontFamily, size: 16))
                    .padding(.bottom, 5)
                    
                    Text(post.text!)
                        .font(.custom(Styles.standardFontFamily, size: 16))
                        .padding(.bottom, 5)
                    
                    if post.imageURL != nil {
                        if post.image != nil {
                            Image(uiImage: post.image!)
                                .resizable()
                                .scaledToFill()
                        }
                        else {
                            ZStack {
                                Color(.gray)
                                    .frame(height: 200)
                                ProgressView()
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(Styles.primaryBackgroundColor2)
                            .cornerRadius(14))
            
            
            if postDirection == .right {
                Image(uiImage: post.user.profileImage()!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }
        .foregroundColor(.white)
        .padding(.bottom, 30)
        .onTapGesture {
            if post.user.uid != Auth.auth().currentUser?.uid {
                showUserProfile = true
            }
        }
        .fullScreenCover(isPresented: $showUserProfile, content: {
            FriendProfileView(user: post.user, showUserProfileView: $showUserProfile)
        })
        
    }
    
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .samplePost, postDirection: .left)
    }
}
