//
//  FriendProfileView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/28/21.
//

import SwiftUI

struct FriendProfileView: View {
    let user: UserProfile
    @State var userPosts: [CustomPost] = [.samplePost, .samplePostWithImage, .samplePost]
    @Binding var showUserProfileView: Bool
    
    let bounds = UIScreen.main.bounds
    
    init(user: UserProfile, showUserProfileView: Binding<Bool>) {
        self.user = user
        // Fetch user's posts
        self._showUserProfileView = showUserProfileView
    }
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: { showUserProfileView = false }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .foregroundColor(Color(Styles.mainColor3))
                .padding(.top, 30)
            
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        UserProfileView(user: user)
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ButtonView(text: "Send a Gift")
                        })
                        .padding(.bottom, 50)
                        
                        ForEach(0..<userPosts.count, id:\.self) { index in
                            PostView(post: userPosts[index], postDirection: index%2==0 ? .left : .right)
                        }
                        Spacer()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(false)
            }
            .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
        }
    }
}

struct FriendProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileView(user: .sampleUser, showUserProfileView: .constant(true))
    }
}
