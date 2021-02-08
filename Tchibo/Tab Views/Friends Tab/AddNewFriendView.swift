//
//  AddNewFriendView.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/1/21.
//

import SwiftUI

struct AddNewFriendView: View {
    let bounds = UIScreen.main.bounds
    @StateObject var friendsViewModel: FriendsViewModel
    @Binding var showAddFriendView: Bool
    
    
    
    @State var searchQuery = ""
    
    
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                HStack {
                    Button(action: { showAddFriendView = false }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .foregroundColor(Color(Styles.mainColor3))
                .padding(.top, 30)
                .padding(.bottom, 30)
                
                HeaderText(text: "Add a New Friend")
                
                let searchQueryBinding = Binding<String>(get: {
                    self.searchQuery
                }, set: {
                    self.searchQuery = $0
                    friendsViewModel.searchAllUsers(withSubstring: searchQuery)
                    if self.searchQuery.isEmpty {
                        friendsViewModel.allUsers.removeAll()
                    }
                })
               
                TextField("Search by username or name...", text: searchQueryBinding)
                    .foregroundColor(.white)
                    .font(.custom(Styles.standardFontFamily, size: 17))
                    .padding(.vertical, 12.5)
                    .padding(.horizontal)
                    .padding(.leading, 20)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(Styles.mainColor3)))
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(UIColor.white))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                        }
                    )
                    .padding(.bottom, 30)
                    .padding(.vertical)
                ForEach(friendsViewModel.allUsers, id: \.uid) { user in
                    VStack{
                        ZStack(alignment: .trailing) {
                            UserProfileCardView(friend: user)
                            
                            Button(action:{
                                friendsViewModel.addFriend(user)
                                showAddFriendView = false
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 13, height: 13)
                                    Text("Add")
                                        .font(.custom(Styles.standardFontFamily, size: 17))
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color(Styles.mainColor3))
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color(Styles.mainColor3)))
                            }
                        }
                        Rectangle()
                            .fill(Color(.gray))
                            .frame(height: 1)
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
        }
    }
}

struct AddNewFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFriendView(friendsViewModel: FriendsViewModel(), showAddFriendView: .constant(true))
    }
}
