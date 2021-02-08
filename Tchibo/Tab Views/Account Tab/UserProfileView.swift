//
//  UserProfileView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/30/21.
//

import SwiftUI

struct UserProfileView: View {
    let user: UserProfile
    let bounds = UIScreen.main.bounds
    var editButtonAction: (() -> ())?
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    
                    CircularProfileImageView(uiImage: user.profileImage()!,
                                             size: bounds.width * 0.32)
                        
                    
                    if let editButtonAction = editButtonAction {
                        Button(action:  editButtonAction, label: {
                            Image(systemName: "wrench.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(Styles.primaryBackgroundColor))
                                .padding(10)
                        })
                        .background(Circle().fill(Color(Styles.mainColor4)))
                    }
                    
                }
                .padding(.vertical)
                
                
                VStack {
                    HStack {
                        Text(user.firstName + " " + user.lastName)
                        Text(" | ")
                            .fontWeight(.light)
                        Text("🇬🇧")
                    }
                    .font(.custom(Styles.standardFontFamily, size: 24))
                    .padding(.bottom, 2.5)
                    
                    Text("@" + user.username)
                        .font(.custom(Styles.standardFontFamily, size: 18))
                }
                .foregroundColor(.white)
                .padding(.bottom, 30)
                
                Spacer()
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            UserProfileView(user: .sampleUser)
        }
    }
}
