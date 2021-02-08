//
//  ContentView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/10/21.
//

import SwiftUI
import FirebaseAuth

enum Tab {
    case account, friends, feed, shop, order
}

class CurrentTab: ObservableObject {
    @Published var currentTab: Tab = .account
}


struct ContentView: View {
    @EnvironmentObject var currentTab: CurrentTab
    
    @StateObject var accountViewModel = AccountViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    @StateObject var feedViewModel = FeedViewModel()
    @StateObject var shopViewModel = ShopViewModel()
    @StateObject var orderViewModel = OrderViewModel()
    
    var body: some View {
            TabView(selection: $currentTab.currentTab) {
                AccountView(accountViewModel: accountViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                            .accentColor(.black)
                        Text("Account")
                    }
                    .onTapGesture {
                        currentTab.currentTab = .account
                    }
                    .tag(Tab.account)
                FriendsView(friendsViewModel: friendsViewModel)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.black)
                            .accentColor(.black)
                        Text("Friends")
                    }
                    .onTapGesture {
                        currentTab.currentTab = .friends
                    }
                    .tag(Tab.friends)
                
                FeedView(feedViewModel: feedViewModel)
                    .tabItem {
                        Image(systemName: "globe")
                            .foregroundColor(.black)
                            .accentColor(.black)
                        Text("Feed")
                    }
                    .onTapGesture {
                        currentTab.currentTab = .feed
                    }
                    .tag(Tab.feed)
                
                ShopView(shopViewModel: shopViewModel, friendsViewModel: friendsViewModel)
                    .tabItem {
                        Image(systemName: "bag.fill")
                            .foregroundColor(.black)
                            .accentColor(.black)
                        Text("Shop")
                    }
                    .onTapGesture {
                        currentTab.currentTab = .shop
                    }
                    .tag(Tab.shop)
                
                OrderView(orderViewModel: OrderViewModel())
                    .tabItem {
                        Image(systemName: "gift.fill")
                            .foregroundColor(.black)
                            .accentColor(.black)
                        Text("Shop")
                    }
                    .onTapGesture {
                        currentTab.currentTab = .order
                    }
                    .tag(Tab.order)
            }
            .onAppear {
                UINavigationBar.appearance().isTranslucent = true
                UINavigationBar.appearance().tintColor = Styles.mainColor3
                UINavigationBar.appearance().backgroundColor = Styles.primaryBackgroundColor
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Styles.mainColor3]
                UITabBar.appearance().barTintColor = Styles.primaryBackgroundColor2
            }
            .accentColor(Color(Styles.mainColor4))
        
    }
    
    
}

struct LandingView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool?

    var body: some View {
        if isLoggedIn != nil, isLoggedIn! {
            ContentView()
        }
        else {
            LoginScreenView()
        }
    }
    
    
    
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
