//
//  AccountView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/20/21.
//

import SwiftUI
import FirebaseAuth
import Firebase


struct AccountView: View {
    @StateObject var accountViewModel: AccountViewModel
    
    @State var rewardPointPercentage: Float = 0
    let bounds = UIScreen.main.bounds
    @State var moodLevel: CGFloat = 0
    
    let maxReferralCount = 5
    @State var currentReferralCount = 2
    
   
    
    
    var body: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            ScrollView(showsIndicators: false) {
//                if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isAnonymous == true {
//
//                    profileSection()
//                }
//                else {
//                    guestAccountView()
//                }
                if accountViewModel.currentUser != nil {
                    profileSection()
                }
                
                
                    
                
                if accountViewModel.userRewards != nil {
                    ZStack {
                        Rectangle()
                            .fill(Color(Styles.mainColor4))
                            .frame(width: bounds.width * 0.85, height: 0)
                            
                        Text("Rewards Zone")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .italic()
                            .font(.custom(Styles.standardFontFamily, size: 38))
                            .padding()
                            .background(Color(Styles.primaryBackgroundColor))
                            .foregroundColor(Color(Styles.mainColor4))
                        
                    }
                    .padding(.bottom, 40)
                    
                    
                    rewardHeaderText("1. Gift Points")
                    
                    giftRewardProgress()
                    
                    Rectangle()
                        .fill(Color(Styles.primaryLabelColor))
                        .frame(width: bounds.width * 0.5, height: 1)
                        .padding(.vertical, 80)
                    
                    rewardHeaderText("2. Post Streak")
                    
                    // post streak view
                    postStreakProgress()
                    
                    
                    Rectangle()
                        .fill(Color(Styles.primaryLabelColor))
                        .frame(width: bounds.width * 0.5, height: 1)
                        .padding(.vertical, 80)
                    
                    rewardHeaderText("3. Referral Points")
                    referralRewardProgress()
                    
                    
                }
                
                
                Button(action: {
                    try? Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                }) {
                    Text("Sign out")
                }
                
            }
        }
        .fullScreenCover(isPresented: $accountViewModel.showAccountSettingsView, content: {
            AccountSettingsView(accountViewModel: accountViewModel)
        })
        
    }
    
    @ViewBuilder
    func postStreakProgress() -> some View {
        VStack {
            if accountViewModel.userRewards!.postStreak != 0 {
                HStack {
                    ForEach(0..<accountViewModel.postStreak.count, id: \.self) { index in
                        Text(accountViewModel.postStreak[index])
                            .font(.system(size: 32))
                            .padding(.bottom)
                    }
                }
                .padding(.bottom)
            }
            
            Text("Post for a week straight to receive $5 in rewards!\n\n(\(7 - accountViewModel.userRewards!.postStreak) more days)")
                .fontWeight(.semibold)
                .font(.custom(Styles.standardFontFamily, size: 18))
                .foregroundColor(Color(.white))
                .frame(width: bounds.width * 0.65)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
    }
    
    func rewardHeaderText(_ text: String) -> some View {
        Text(text)
            .fontWeight(.medium)
            .font(.custom(Styles.standardFontFamily, size: 32))
            .foregroundColor(Color(Styles.mainColor5))
            .padding(.bottom, 40)
    }
    
    @ViewBuilder
    func guestAccountView() -> some View {
        Text("Create an account to receive rewards!")
            .font(.custom(Styles.standardFontFamily, size: 40))
            .foregroundColor(Color(Styles.mainColor3))
            .padding(.top, 20)
    }
    
    @ViewBuilder
    func profileSection() -> some View {
        VStack {
    //        Text("Hi \(Auth.auth().currentUser?.email ?? "there").")
    //            .font(.custom(Styles.standardFontFamily, size: 40))
    //            .foregroundColor(Color(Styles.mainColor3))
    //            .padding(.top, 20)
            
            Text("Hi \(accountViewModel.currentUser!.firstName).")
                .fontWeight(.light)
                .font(.custom(Styles.standardFontFamily, size: 40))
                .foregroundColor(Color(Styles.mainColor3))
                .padding(.top, 20)
                
            
            
            UserProfileView(user: accountViewModel.currentUser!) {
                accountViewModel.showAccountSettingsView = true
            }
        }
    }
    
    @ViewBuilder
    func giftRewardProgress() -> some View {
        VStack {
            CircleProgressBar(progress: Float((accountViewModel.userRewards!.giftCount))/100)
                .frame(width: 150, height: 150)
                .onAppear {
                    rewardPointPercentage = 0.3
                }
                .padding(.bottom, 40)
            
            Text("Gift another $\(Float(100 - accountViewModel.userRewards!.giftCount).asStringWithDecimalPlaces(0)) worth of coffee to get your next reward!")
                .fontWeight(.semibold)
                .font(.custom(Styles.standardFontFamily, size: 18))
                .foregroundColor(Color(.white))
                .padding(.horizontal, bounds.width * 0.2)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }
            
    }
    
    @ViewBuilder
    func referralRewardProgress() -> some View {
        VStack {
            HStack {
                ForEach(0..<maxReferralCount, id: \.self) { index in
                    if index < accountViewModel.userRewards!.referralCount {
                        Image(systemName: "person.fill")
                            .resizable()
                    }
                    else {
                        Image(systemName: "person")
                            .resizable()
                    }
                }
                .foregroundColor(Color(Styles.mainColor4))
                .frame(width: 25, height: 25)
                .padding(5)
            }
            .padding(.bottom)
            
            Text("Tell \(maxReferralCount - accountViewModel.userRewards!.referralCount) more friends to sign up to get your next reward!")
                .fontWeight(.semibold)
                .font(.custom(Styles.standardFontFamily, size: 18))
                .foregroundColor(Color(.white))
                .frame(width: bounds.width * 0.65)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            ZStack {
                Rectangle()
                    .stroke(Color(Styles.mainColor3), lineWidth: 3)
                    .frame(width: bounds.width * 0.8)
                    .offset(y: 30)
                VStack {
                    Text("Referral Code")
                        .fontWeight(.medium)
                        .font(.custom(Styles.standardFontFamily, size: 22))
                        .foregroundColor(Color(Styles.mainColor4))
                        .padding()
                        .padding(.bottom, 5)
                        .background(Color(Styles.primaryBackgroundColor))
                    Text(accountViewModel.userRewards!.referralCode)
                        .font(.custom(Styles.standardFontFamily, size: 22))
                        .foregroundColor(Color(.black))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(Styles.mainColor5)))
                }
            }
            .padding(.bottom, bounds.height * 0.03)
        }
    }
}



struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
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
