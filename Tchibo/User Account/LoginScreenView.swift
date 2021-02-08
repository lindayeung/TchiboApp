//
//  LoginScreenView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/20/21.
//

import SwiftUI
import FirebaseAuth

struct LoginScreenView: View {
    
    @State var showRegister = false
    @State var showLogin = false
    
    func signInAsGuest() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            guard let user = authResult?.user else {
                print("Could not sign in as anonymous user.")
                return
            }
            
            let isAnonymous = user.isAnonymous
            let uid = user.uid
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            body(forSize: geometry.size)
        }
    }
    
    
    func body(forSize size: CGSize) -> some View {
        ZStack {
            Color(#colorLiteral(red: 0.1882458925, green: 0.1881759465, blue: 0.1925152242, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("tchibo_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .padding(.bottom,20)
                Text("Every week a new world.")
                    .font(.custom(Styles.standardFontFamily, size: 20))
                    .foregroundColor(Color(Styles.primaryTextColor))
                
                VStack(spacing: 30) {
                    Button(action: {
                        showLogin = true
                    }, label: {
                        ButtonView(text: "Login")
                    })
                    .fullScreenCover(isPresented: $showLogin, content: {
                        SignInView(showLogin: $showLogin)
                    })
                    
                    Button(action: {
                        showRegister = true
                    }, label: {
                        ButtonView(text: "Register")
                    })
                    .fullScreenCover(isPresented: $showRegister, content: {
                        ZStack {
                            Color(Styles.primaryBackgroundColor)
                                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            RegisterView(showRegister: $showRegister)
                        }
                    })
                }
                .padding(.horizontal, 80)
                .padding(.top, 100)
                
                Button(action: { signInAsGuest() }, label: {
                    Text ("Continue as guest")
                        .font(.body)
                        .foregroundColor(Color(UIColor.systemGray6))
                        .padding(.top)
                })
                
                
            }
            
            
            
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
