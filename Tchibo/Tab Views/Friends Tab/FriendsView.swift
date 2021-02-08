//
//  FriendsView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/27/21.
//

import SwiftUI


struct FriendsView: View {
    @State var friends: [UserProfile] = Array(repeating: UserProfile.sampleUser, count: 20)
    let bounds = UIScreen.main.bounds
    @StateObject var friendsViewModel: FriendsViewModel
    
    @State var showAddFriendView: Bool = false
    
    @State var showFriendsProfileView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Styles.primaryBackgroundColor)
                    .edgesIgnoringSafeArea(.top)
                
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Friends")
                                    .font(.custom(Styles.standardFontFamily, size: 34))
                                    .bold()
                                    .foregroundColor(Color(Styles.mainColor3))
                                Spacer()
                                Button(action: {
                                    showAddFriendView = true
                                }, label: {
                                    HStack {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 15, height: 15, alignment: .trailing)
                                            .foregroundColor(Color.white)
                                        Text("Add").font(.custom(Styles.standardFontFamily, size: 18))
                                            .foregroundColor(Color.white)
                                    }
                                })
                                .fullScreenCover(isPresented: $showAddFriendView, content: {
                                    AddNewFriendView(friendsViewModel: friendsViewModel, showAddFriendView: $showAddFriendView)
                                })
                             
                            }
                            .padding(.vertical)
                                
                            friendListView()
                            
                            
                        }
                        .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
                    }
                    .navigationBarHidden(true)
                }
        }
    }
    
    @State var showUserProfileView: Bool = false
    @State var searchQuery = ""

    @ViewBuilder
    func friendListView() -> some View {
        let searchQueryBinding = Binding<String>(get: {
            self.searchQuery
        }, set: {
            self.searchQuery = $0
            friendsViewModel.searchFriends(withSubstring: searchQuery)
        })
        
        TextField("Search for a friend...", text: searchQueryBinding)
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
        
        ForEach(friendsViewModel.visibleFriends, id: \.uid) { friend in
                
            VStack {
                Button(action: { showUserProfileView = true }, label: {
                    UserProfileCardView(friend: friend)
                })
                Rectangle()
                    .fill(Color(.gray))
                    .frame(height: 1)
                    .padding(.bottom, 10)
            }
            .fullScreenCover(isPresented: $showUserProfileView, content: {
                FriendProfileView(user: friend, showUserProfileView: $showUserProfileView)
            })
        }
    }
}












struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: .constant("Friends")) {
            AccountView(accountViewModel: AccountViewModel())
                .tabItem {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Account")
                }
            FriendsView(friendsViewModel: FriendsViewModel())
                .tabItem {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Friends")
                }
                .tag("Friends")
            
            FeedView(feedViewModel: FeedViewModel())
                .tabItem {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Feed")
                }
            ShopView(shopViewModel: ShopViewModel(), friendsViewModel: FriendsViewModel())
                .tabItem {
                    Image(systemName: "bag.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Shop")
                }
                .tag("Shop")
            Text("Gifts")
                .tabItem {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Shop")
                }
        }
        .onAppear {
            UITabBar.appearance().barTintColor = Styles.primaryBackgroundColor2
        }
        .accentColor(Color(Styles.mainColor4))
    }
}
