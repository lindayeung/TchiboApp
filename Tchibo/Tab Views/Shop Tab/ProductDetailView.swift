//
//  ProductDetailView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/28/21.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject var product: Product
    @StateObject var giftViewModel = GiftViewModel()
    @Binding var showProductDetailView: Bool
    @StateObject var friendsViewModel: FriendsViewModel
    
    
    let bounds = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    HStack {
                        Button(action: { showProductDetailView = false }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    .foregroundColor(Color(Styles.mainColor3))
                    .padding(.vertical)
                    .padding(.leading, bounds.width * Styles.tabPageMarginMultiple)
                    
                    // Image Gallery
                    TabView {
                        ForEach(0..<product.galleryImages.count, id: \.self) { index in
                            Image(uiImage: product.galleryImages[index]!)
                                .resizable()
                                .scaledToFit()
                        }
                        
                    }
                    .background(Color.black)
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 350)
                    
                
                    VStack {
                        HStack(alignment: .top, spacing: 20) {
                            Text(product.data.title!)
                                .font(.custom(Styles.standardFontFamily, size: 25))
                                .fontWeight(.medium)
                            Spacer()
                            Text(product.data.price_amount!.asStringWithDecimalPlaces(2) + " €")
                                .font(.custom(Styles.standardFontFamily, size: 25))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical)
                        
                        HStack {
                            Button(action: {
                                giftViewModel.product = product
                                giftViewModel.showSendGiftView = true
                            }, label: {
                                ButtonView(text: "Gift", width: 120)
                            })
                            .fullScreenCover(isPresented: $giftViewModel.showSendGiftView, content: {
                                SendGiftView(friendsViewModel: friendsViewModel, giftViewModel: giftViewModel)
                            })
                            Spacer()
                            Button(action: { addProductToCurrentCart(product: product) {
                                showProductDetailView = false
                            }}, label: {
                                ButtonView(text: "Add to my Bundle", width: 205)
                            })
                        }
                        .padding(.vertical)
                        
                        Text(product.data.structuredDescription!)
                            .font(.custom(Styles.standardFontFamily, size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineSpacing(10)
                            .padding(.vertical)
                    }
                    .padding(.horizontal, bounds.width * 0.08)
                }
                .edgesIgnoringSafeArea(.bottom)
                
                Spacer()
            }
            .navigationTitle(product.data.type!.capitalized)
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailView(product: .sampleProduct, showProductDetailView: .constant(true), friendsViewModel: FriendsViewModel())
        }
    }
}
