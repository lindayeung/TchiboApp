//
//  ConfirmGiftPopover.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/29/21.
//

import SwiftUI

struct ConfirmGiftPopover: View {
    let bounds = UIScreen.main.bounds
    //var recipient: UserProfile
    @Binding var showPopover: Bool
    @StateObject var giftViewModel: GiftViewModel
    @EnvironmentObject var currentTab: CurrentTab
    
    @State var giftText: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(#colorLiteral(red: 0.2306312025, green: 0.231048286, blue: 0.2359012365, alpha: 1)))
                .frame(width: bounds.width * 0.7, height: bounds.height * 0.55)
                .background(Rectangle().fill(Color(#colorLiteral(red: 0.1302707493, green: 0.1305101514, blue: 0.1332474351, alpha: 1))).blur(radius: 30))
                    VStack {
                        Text("Wrapping gift..")
                            .font(.custom(Styles.standardFontFamily, size: 22))
                            .foregroundColor(Color(Styles.primaryTextColor))
                            .fontWeight(.medium)
                            .padding(.bottom)
                        
                        HStack(spacing: 20) {
                            // Set as the current authenticated user's profile Image
                            CircularProfileImageView(uiImage: giftViewModel.recipient!.profileImage()!, size: 50)
                            Image(systemName: "arrow.right")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            CircularProfileImageView(uiImage: giftViewModel.recipient!.profileImage()!, size: 50)
                        }
                        .padding(.bottom, 30)
                        
                        VStack {
                            Text("Send with a message?")
                                .fontWeight(.medium)
                                .padding(.bottom, 15)
                                .foregroundColor(Color(Styles.primaryTextColor))
                                .font(.custom(Styles.standardFontFamily, size: 18))
                                
                            
                            ZStack(alignment: .topLeading) {
//                                Text("(optional message...)")
//                                    .font(.custom(Styles.standardFontFamily, size: 18))
//                                    .italic()
//                                    .foregroundColor(Color(Styles.primaryTextColor))
//                                    .padding(15)
//                                    .offset(y: 5)
//                                    .opacity(giftText.isEmpty ? 1 : 0)
                                
                                TextEditor(text: $giftViewModel.message)
                                    .foregroundColor(Color(Styles.primaryTextColor))
                                    .frame(height: bounds.height * 0.125)
                                    .padding(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(Styles.mainColor3), lineWidth: 3)
                                    )
                            }
                        }
                        .font(.custom(Styles.standardFontFamily, size: 18))
                        .padding(.horizontal, bounds.width * 0.2)
                        .padding(.bottom)
                        
                            
                        
                        VStack {
                            Button(action: {
                                giftViewModel.sendGift {
                                    currentTab.currentTab = .feed
                                }
                            }, label: {
                                ButtonView(text: "Send!", width: 100)
                            })
                            Button(action: {
                                giftViewModel.message = ""
                                    showPopover = false
                            }, label: {
                                Text("Cancel")
                                    .font(.custom(Styles.standardFontFamily, size: 16))
                                    .foregroundColor(Color.white)
                            })
                            
                        }
                    }
                
            
                
        }
        .background(BackgroundClearView())
    }
}

struct ConfirmGiftPopover_Previews: PreviewProvider {
    static func sendGiftTo(_ recipient_uid: String) {
        print("sending gift to \(recipient_uid)...")
    }
    
    static var previews: some View {
        ConfirmGiftPopover(showPopover: .constant(true), giftViewModel: GiftViewModel()).environmentObject(CurrentTab())
            
    }
}


