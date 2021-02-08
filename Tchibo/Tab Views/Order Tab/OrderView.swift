//
//  OrderView.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import SwiftUI

enum OrderPage: String, CaseIterable, Identifiable {
    var id: OrderPage { self }
    case gifts = "Available Gifts"
    case currentOrder = "Current Order"
    case trackOrder = "Track Orders"
    case pastOrder = "Past Orders"
}

struct OrderView: View {
    @StateObject var orderViewModel: OrderViewModel
    
    let bounds = UIScreen.main.bounds
    @State var currentPage: OrderPage = .currentOrder
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                HeaderText(text: "Gifts and Orders")
                    .padding(.bottom, 40)
                    .padding(.top)
                VStack(alignment: .leading){
                    toggleViewBar()
                        .padding(.bottom, 30)
                    
                    switch currentPage {
                    case .gifts: availableGifts()
                    case .currentOrder: currentBasket()
                    case .trackOrder: EmptyView()
                    case .pastOrder: EmptyView()
                    }
                    
                }
                Spacer()
                
            }
            .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
        }
    }
    
    @ViewBuilder
    func currentBasket() -> some View {
        VStack {
            if orderViewModel.currentBasketOrderItems.count == 0  {
                HStack {
                    Spacer()
                    VStack(spacing: 60) {
                        Text("Your basket is empty.")
                            
                        Text("Head over to the shop to get your fix of caffeine!")
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                    
                    }
                    .padding(.top, 80)
                    Spacer()
                }
                .foregroundColor(Color(Styles.primaryTextColor))
                .font(.custom(Styles.standardFontFamily, size: 18))
            }
                
            else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        ForEach(orderViewModel.currentBasketOrderItems) { orderItem in
                            cardViewFor(cartItem: orderItem)
                            
                            Rectangle()
                                .foregroundColor(Color(.gray))
                                .frame(height: 1)
                        }
                    }
                }
                VStack {
                    
                    VStack(spacing: 10) {
                        Text("Subtotal:  \(orderViewModel.orderTotal.asStringWithDecimalPlaces(2))")
                        
                        if orderViewModel.credit != 0 {
                            Text("Rewards: -\(orderViewModel.credit.asStringWithDecimalPlaces(2))")
                                .foregroundColor(.red)
                        }
                        Text("Total: \((orderViewModel.orderTotal - orderViewModel.credit).asStringWithDecimalPlaces(2))")
                    }
                    .font(.custom(Styles.standardFontFamily, size: 18))
                    .foregroundColor(Color(Styles.primaryTextColor))
                    
                    
                    Button(action: {}, label: {
                        ButtonView(text: "Checkout", width: 120)
                    })
                    .padding(.bottom)
                }
            }
        }
    }
    
    func cardViewFor(cartItem orderItem: OrderItem) -> some View {
        HStack(alignment: .top) {
            Image(uiImage: orderItem.product.defaultImage ?? UIImage(named: "Coffee")!)
                    .resizable()
                    .frame(width: 90, height: 100)
          
            VStack(alignment: .leading) {
                Text(orderItem.product.data.title!)
                    .fontWeight(.medium)
                    .padding(.bottom, 10)
                HStack {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(Styles.mainColor3))
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("x \(orderItem.quantity)")
                        Group {
                            if orderItem.giftID == nil {
                                Text("\(orderItem.totalPrice.asStringWithDecimalPlaces(2))")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(Styles.mainColor3))
                            }
                            else {
                                Text("FREE")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(Styles.mainColor3))
                            }
                        }
                    }
                }
                .font(.custom(Styles.standardFontFamily, size: 18))
                
            }
            .padding(.leading)
            .foregroundColor(Color(Styles.primaryTextColor))
        }
        .padding()
    }
    
  
    func availableGifts() -> some View {
        VStack {
            if orderViewModel.currentBasketOrderItems.count == 0  {
                HStack {
                    Spacer()
                    VStack(spacing: 60) {
                        Text("No redeemable gifts!")
                            
                        Text("Tell your friends if they send you a gift they will be gifted with reward points too!")
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                        
                    }
                    .padding(.top, 80)
                    Spacer()
                }
                .foregroundColor(Color(Styles.primaryTextColor))
                .font(.custom(Styles.standardFontFamily, size: 18))
            }
            else {
                VStack(alignment: .leading) {
             
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(orderViewModel.availableGiftOrderItems) { giftOrderItem in
                                cardViewFor(giftOrderItem: giftOrderItem)
                                    .padding(.bottom)
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    @State var showUserProfile = false
    
    func cardViewFor(giftOrderItem: OrderItem) -> some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .bottom) {
                Text("from \(giftOrderItem.creator.firstName) \(giftOrderItem.creator.lastName)")
                                    .foregroundColor(Color(Styles.mainColor4))
                Button(action: {
                    showUserProfile = true
                }, label: {
                    CircularProfileImageView(uiImage: giftOrderItem.creator.profileImage()!,
                                             size: 45)
                })
                .fullScreenCover(isPresented: $showUserProfile, content: {
                    FriendProfileView(user: giftOrderItem.creator, showUserProfileView: $showUserProfile)
                })
                
            }
            .padding(.trailing)
            
            HStack(alignment: .top) {
                Image(uiImage: giftOrderItem.product.defaultImage!)
                    .resizable()
                    .frame(width: 90, height: 100)
                VStack(alignment: .trailing) {
                    Text(giftOrderItem.product.data.title!)
                        .fontWeight(.medium)
                        .padding(.leading)
                    Button(action: {
                        orderViewModel.addToCurrentBasket(giftOrderItem)
                    }, label: {
                        ButtonView(text: "add to cart", width: 120, height: 30)
                    })
                }
                .foregroundColor(Color(Styles.primaryTextColor))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color(Styles.mainColor3), lineWidth: 2))
        }
        .padding(.bottom, 30)
    }
    
    
    
    func toggleViewBar() -> some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(OrderPage.allCases) { orderPage in
                            ZStack(alignment: .bottomLeading) {
                                Text(orderPage.rawValue)
                                    .fontWeight(.light)
                                    .padding(.trailing)
                                    .frame(width: 150)
                            }
                            .onTapGesture {
                                currentPage = orderPage
                            }
                        }
                    }
                    .font(.custom(Styles.standardFontFamily, size: 22))
                    .foregroundColor(Color(Styles.mainColor2))
                    
                    Rectangle().fill(Color(Styles.mainColor2))
                        .frame(width: 130, height: 1)
                        .offset(x: pageFocusOffset())
                        .animation(.linear)
                }
            }
        }
    }
    
    func pageFocusOffset() -> CGFloat {
        switch currentPage {
        case .gifts: return 0
        case .currentOrder: return 160
        case .trackOrder: return 320
        case .pastOrder: return 480
        }
    }
    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: .constant("Order")) {
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
            OrderView(orderViewModel: OrderViewModel())
                .tabItem {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("My Orders")
                }
                .tag("Order")
        }
        .onAppear {
            UITabBar.appearance().barTintColor = Styles.primaryBackgroundColor2
        }
        .accentColor(Color(Styles.mainColor4))
    }
}
