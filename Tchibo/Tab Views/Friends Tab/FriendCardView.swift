//
//  FriendCardView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/29/21.
//

import SwiftUI

struct UserProfileCardView: View {
    var friend: UserProfile
    
    var body: some View {
        
        HStack {
            CircularProfileImageView(uiImage: friend.profileImage, size: 45)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.firstName + " " + friend.lastName)
                    .fontWeight(.bold)
                    .font(.custom(Styles.standardFontFamily, size: 17))
                    .padding(.leading)
                    .foregroundColor(.white)
                Text("@" + friend.username)
                    .font(.custom(Styles.standardFontFamily, size: 17))
                    .padding(.leading)
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}

struct FriendCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment:.topLeading) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            UserProfileCardView(friend: .sampleUser)
        }
    }
}
