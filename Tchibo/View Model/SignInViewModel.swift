//
//  SignInViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/6/21.
//

import Foundation
import Firebase
import CryptoKit

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showIncorrectLogin = false
    
    
    // TODO
    func signIn() {
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
        }
        
    }
    
    
}
