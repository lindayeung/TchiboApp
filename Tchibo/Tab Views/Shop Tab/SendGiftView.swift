//
//  SendGiftView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/29/21.
//

import SwiftUI
import FirebaseAuth

struct SendGiftView: View {
    @StateObject var friendsViewModel: FriendsViewModel
    let bounds = UIScreen.main.bounds
    @StateObject var giftViewModel: GiftViewModel

    
    private func sendGiftTo(_ recipient_uid: String) {
        giftViewModel.showConfirmGiftPopover = false
        print("sending gift to \(recipient_uid)...")
    }
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .opacity(giftViewModel.showConfirmGiftPopover ? 1 : 0).animation(.linear)
            
            VStack {
                HStack {
                    Button(action: { giftViewModel.showSendGiftView = false }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .foregroundColor(Color(Styles.mainColor3))
                .padding(.vertical)
                
                HStack {
                    Text("Which friend needs some caffeine?")
                        .font(.custom(Styles.standardFontFamily, size: 28))
                        .fontWeight(.light)
                        .foregroundColor(Color(Styles.mainColor3))
                    Spacer()
                }
                .padding(.bottom)
                
                ScrollView {
                    friendListView()
                }
                .padding(.vertical)
            }
            .padding(.top)
            .padding(.horizontal, 30)
        }
        .fullScreenCover(isPresented: $giftViewModel.showConfirmGiftPopover, content: {
            ConfirmGiftPopover(showPopover: $giftViewModel.showConfirmGiftPopover,
                               giftViewModel: giftViewModel)
        })
    }
    
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
            Button(action: {
                giftViewModel.recipient = friend
                giftViewModel.showConfirmGiftPopover = true
            }, label: {
                VStack{
                    UserProfileCardView(friend: friend)
                    Rectangle()
                        .fill(Color(.gray))
                        .frame(height: 1)
                }
                .padding(.bottom, 10)
            })
        }
    }
}

struct SendGiftView_Previews: PreviewProvider {
    static var previews: some View {
        SendGiftView(friendsViewModel: FriendsViewModel(), giftViewModel: GiftViewModel())
    }
}
