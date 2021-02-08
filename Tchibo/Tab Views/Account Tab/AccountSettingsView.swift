//
//  EditAccountView.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import SwiftUI
import Firebase

struct AccountSettingsView: View {
    @StateObject var accountViewModel: AccountViewModel
    
    @State var editProfileImage: UIImage? = UIImage(named: "default_profile")!
    @State var showImagePicker = false
    
    @State var editFirstName = ""
    @State var editLastName = ""
    
    @State var selectedCountryIndex = -1
    @State var selectingCountry = false
    
    
    let bounds = UIScreen.main.bounds
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(Styles.primaryBackgroundColor)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        editProfileImage = accountViewModel.currentUser!.profileImage()
                        editFirstName = accountViewModel.currentUser!.firstName
                        editLastName = accountViewModel.currentUser!.lastName
                    }
                VStack {
                    
                    HStack {
                        Button(action: { accountViewModel.showAccountSettingsView = false}) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        Button(action: {
                            accountViewModel.updateUserProfile(editProfileImage: editProfileImage!,
                                editFirstName: editFirstName.trimmingCharacters(in: .whitespacesAndNewlines),
                                                               editLastName: editLastName.trimmingCharacters(in: .whitespacesAndNewlines),
                                                               selectedCountryIndex: selectedCountryIndex)
                        }, label: {
                            ButtonView(text: "Save", width: 100, height: 40)
                        })
                    }
                    .foregroundColor(Color(Styles.mainColor3))
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    
                    HeaderText(text: "Profile Settings")
                    HStack(alignment: .top) {
                        VStack(spacing: 10) {
                            Button(action: { showImagePicker = true}, label: {
                                ZStack(alignment: .bottomTrailing) {
                                    CircularProfileImageView(uiImage: editProfileImage!,
                                                             size: bounds.width * 0.3)
                                    Button(action: { showImagePicker = true }, label: {
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color(Styles.primaryBackgroundColor))
                                            .padding(10)
                                    })
                                    .background(Circle().fill(Color(Styles.mainColor4)))
                                    
                                }
                            })
                            
                            
                            Text("Tap to edit")
                                .font(.custom(Styles.standardFontFamily, size: 18))
                                .foregroundColor(Color(Styles.primaryTextColor))
                        }
                        .padding(.trailing)
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(showPicker: $showImagePicker, image: $editProfileImage)
                        }
                        editBasicInfoView()
                    }
                    
                    countryPickerView()
                    
                    HeaderText(text: "Account Settings")
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 25) {
                            accountInfoView(withLabel: "Username", data: "@" + accountViewModel.currentUser!.username)
                            accountInfoView(withLabel: "Email", data: Auth.auth().currentUser!.email!)
                            accountInfoView(withLabel: "Phone", data: "4102228888")
                            
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 15) {
                        accountOptionView(withLabel: "Payment")
                        accountOptionView(withLabel: "Currency")
                        accountOptionView(withLabel: "Language")
                        accountOptionView(withLabel: "Reset Password")
                        accountOptionView(withLabel: "Sign out")
                    }
                    
                    
                    
                    
                    
                    Spacer()
                }
                .padding(.horizontal, bounds.width * Styles.tabPageMarginMultiple)
                .padding(.top)
            }
        }
        .background(Color(Styles.primaryBackgroundColor)
                        .edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
    
    func accountOptionView(withLabel label: String) -> some View {
        Color(Styles.primaryBackgroundColor3)
            .overlay(
                HStack {
                    Text(label)
                        .padding(.leading)
                        .foregroundColor(Color(Styles.mainColor5))
                        .font(.custom(Styles.standardFontFamily, size: 18))
                    Spacer()
                }
            )
            .frame(height: 50)
            .cornerRadius(15)
    }
    
    func accountInfoView(withLabel label: String, data: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(Color(Styles.mainColor3))
                .fontWeight(.bold)
                .font(.custom(Styles.standardFontFamily, size: 20))
                .padding(.trailing, 10)
            Text(data)
                .foregroundColor(Color(Styles.primaryTextColor))
                .font(.custom(Styles.standardFontFamily, size: 18))
        }
    }
    
    func countryPickerView() -> some View {
        Group {
            if selectingCountry {
                Picker(accountViewModel.currentUser!.country.rawValue, selection: $selectedCountryIndex) {
                    ForEach(0..<Country.allCases.count) { index in
                        Text(Country.allCases[index].rawValue)
                            .font(.custom(Styles.standardFontFamily, size: 20))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 120)
                .clipped()
            }
        }
        .onTapGesture {
            withAnimation {
                selectingCountry = false
            }
        }
    }
    
    func editBasicInfoView() -> some View {
        VStack(spacing: 25) {
            TextField(accountViewModel.currentUser!.firstName, text: $editFirstName)
                .inputTextFieldStyle()
            
            TextField(accountViewModel.currentUser!.firstName, text: $editLastName)
                .inputTextFieldStyle()
            
            HStack {
                Text(selectedCountryIndex == -1 ? accountViewModel.currentUser!.country.rawValue : Country.allCases[selectedCountryIndex].rawValue)
                    .onTapGesture {
                        withAnimation {
                            selectingCountry.toggle()
                        }
                    }
                Spacer()
            }
            .inputTextFieldStyle()
        }
        .foregroundColor(Color(Styles.primaryTextColor))
        .font(.custom(Styles.standardFontFamily, size: 18))
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            AccountSettingsView(accountViewModel: AccountViewModel())
        }
        
    }
}
