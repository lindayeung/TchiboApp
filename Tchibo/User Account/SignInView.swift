//
//  SignInView.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/6/21.
//

import SwiftUI

struct SignInView: View {
    let bounds = UIScreen.main.bounds
    @StateObject var signInViewModel = SignInViewModel()
    @Binding var showLogin: Bool
    
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1882458925, green: 0.1881759465, blue: 0.1925152242, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        showLogin = false
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color(Styles.mainColor2))
                            .frame(width: 20, height: 20)
                    })
                    Spacer()
                    Text("Sign In")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 20))
                        .foregroundColor(Color(Styles.primaryTextColor))
                    Spacer()
                }
                .padding(.top)
                
                HStack {
                    Text("Welcome Back!")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                        .foregroundColor(Color(Styles.mainColor3))
                        .padding(.top, bounds.height * 0.2)
                    Spacer()
                }
                .padding(.bottom, 80)
                
                VStack(spacing: 60) {
                    BasicInfoTextField(label: "Email", text: $signInViewModel.email)
                    BasicInfoTextField(label: "Password", text: $signInViewModel.password)
                }
                .padding(.bottom, 80)
                
                Button(action: { signInViewModel.signIn() }, label: {
                    ButtonView(text: "Sign In")
                })
                
                Spacer()
            }
            .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showLogin: .constant(true))
    }
}
