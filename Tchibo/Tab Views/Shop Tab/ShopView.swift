//
//  ShopView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/24/21.
//

import SwiftUI




struct ShopView: View {
    @StateObject var shopViewModel: ShopViewModel
    @StateObject var friendsViewModel: FriendsViewModel
    @State var selectedProduct: Product = Product.sampleProduct
    
    
    
    let bounds = UIScreen.main.bounds
    
    @ViewBuilder
    func categoryButtonView(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(Styles.mainColor2), lineWidth: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(Styles.mainColor2))
                            .opacity(0)
                        )
            )
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(Styles.primaryBackgroundColor)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    HeaderText(text: "Shop")
                        .padding(.vertical)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Text("Coffee")
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(Styles.mainColor2))
                                )
                            categoryButtonView("Apparel")
                            categoryButtonView("Gift Cards")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .font(.custom(Styles.standardFontFamily, size: 16))
                    }
                    
                    
                    ScrollView {
                        ForEach(shopViewModel.visibleShopItems, id: \.id) { product in
                            VStack {
                                Rectangle()
                                    .fill(Color(Styles.mainColor1))
                                    .frame(height:0.5)
                                
                                Button(action: {
                                    shopViewModel.selectedProduct = product
                                    shopViewModel.showProductDetailView = true
                                }, label: {
                                    ProductCardView(product: product)
                                })
                            }
                        }
                    }
                }
                .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
                .navigationBarHidden(true)
            }
            .fullScreenCover(isPresented: $shopViewModel.showProductDetailView, content: {
                ProductDetailView(product: shopViewModel.selectedProduct!, showProductDetailView: $shopViewModel.showProductDetailView, friendsViewModel: friendsViewModel)
            })
        }
    }
}









struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: .constant("Shop")) {
            AccountView(accountViewModel: AccountViewModel())
                .tabItem {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                        .accentColor(.black)
                    Text("Account")
                }
            Text("Feed")
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
