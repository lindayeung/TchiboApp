//
//  FeedView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/21/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import PhotosUI

enum FeedTab { case global, friends, me }


struct FeedView: View {
    let bounds = UIScreen.main.bounds
    
    @State var feedTabSelection: FeedTab = .me
    @StateObject var feedViewModel: FeedViewModel
    
    @State var creatingNewPost = false
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    feedTabBar()
                    Spacer()
                    Button(action: {
                        creatingNewPost = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.top)
                .fullScreenCover(isPresented: $creatingNewPost, content: {
                    CreateNewPostView(feedViewModel: feedViewModel,
                                      creatingNewPost: $creatingNewPost)
                })
                
                if feedTabSelection == .global {
                    globalPostList()
                }
                else if feedTabSelection == .friends {
                    friendPostList()
                }
                else if feedTabSelection == .me {
                    userPostList()
                }
            }
            .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
            
            
        }
        
    }
    
    
    @ViewBuilder
    private func globalPostList() -> some View {
        ScrollView {
            ForEach(feedViewModel.globalPosts, id:\.postID) { post in
                //PostView(post: feedViewModel.userPosts[index], postDirection: index%2==0 ? .left : .right)
                if post.feedItemType == .customPost, let customPost = post as? CustomPost {
                    PostView(post: customPost, postDirection: .left)
                }
                else if let giftPost = post as? GiftPost {
                    GiftTransactionPostView(gift: giftPost.gift())
                }
            }
        }
        .padding(.top, 30)
    }
    
    
    @ViewBuilder
    private func friendPostList() -> some View {
        ScrollView {
            ForEach(feedViewModel.friendPosts, id:\.postID) { post in
                //PostView(post: feedViewModel.userPosts[index], postDirection: index%2==0 ? .left : .right)
                if post.feedItemType == .customPost, let customPost = post as? CustomPost {
                    PostView(post: customPost, postDirection: .left)
                }
                else if let giftPost = post as? GiftPost {
                    GiftTransactionPostView(gift: giftPost.gift())
                }
            }
        }
        .padding(.top, 30)
    }
    
    
    @ViewBuilder
    private func userPostList() -> some View {
        ScrollView {
            ForEach(feedViewModel.userPosts, id:\.postID) { post in
                //PostView(post: feedViewModel.userPosts[index], postDirection: index%2==0 ? .left : .right)
                if post.feedItemType == .customPost, let customPost = post as? CustomPost {
                    PostView(post: customPost, postDirection: .left)
                }
                else if let giftPost = post as? GiftPost {
                    GiftTransactionPostView(gift: giftPost.gift())
                }
            }
        }
        .padding(.top, 30)
    }
    
    
    @ViewBuilder
    private func feedTabBar() -> some View {
        HStack {
            VStack {
                Image(systemName: "globe")
                Text("Global")
                    .font(.caption)
            }
            .padding(.vertical,5)
            .frame(width: bounds.width * 0.22)
            .background(feedTabSelection == .global ? Color(Styles.mainColor2) : .clear)
            .onTapGesture {
                feedTabSelection = .global
            }
               
            VStack{
                Image(systemName: "person.2.fill")
                Text("Friends")
                    .font(.caption)
            }
            .padding(.vertical,5)
            .frame(width: bounds.width * 0.22)
            .background(feedTabSelection == .friends ? Color(Styles.mainColor2) : .clear)
            .onTapGesture {
                feedTabSelection = .friends
            }
            
            VStack {
                Image(systemName: "person.fill")
                Text("Me")
                    .font(.caption)
            }
            .padding(.vertical,5)
            .frame(width: bounds.width * 0.22)
            .background(feedTabSelection == .me ? Color(Styles.mainColor2) : .clear)
            .onTapGesture {
                feedTabSelection = .me
            }
        }
        .background(Color(Styles.primaryBackgroundColor2))
        .foregroundColor(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }

    
}












struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: .constant("Feed")) {
            AccountView(accountViewModel: AccountViewModel())
                .tabItem {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Account")
                }
            FeedView(feedViewModel: FeedViewModel())
                .tabItem {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Feed")
                }
                .tag("Feed")
                
            Text("Shop")
                .tabItem {
                    Image(systemName: "bag.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Shop")
                }
            
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
