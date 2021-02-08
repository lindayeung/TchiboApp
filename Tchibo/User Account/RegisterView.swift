//
//  RegisterView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/10/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import iPhoneNumberField
import CryptoKit





enum RegistrationForm { case email, phone, basic, password }

struct RegisterView: View {
    

    @Binding var showRegister: Bool
    @State var showLocationForms = false
    @State var FormOffset: CGFloat = 0
    
    @State var currentForm: RegistrationForm? = .email
    
    
    
    var body: some View {
        GeometryReader { geometry in
            body(forSize: geometry.size)
        }
        .onAppear {
            addKeyboardObservers()
        }
    }
    
    func body(forSize size: CGSize) -> some View {
        VStack {
            HStack {
                Button(action: {
                    showRegister = false
                    currentForm = .email
                    
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(Color(Styles.mainColor2))
                        .frame(width: 25, height: 25)
                })
                Spacer()
                Text("Register")
                    .font(.custom(Styles.standardFontFamilyMedium, size: 20))
                    .foregroundColor(Color(Styles.primaryTextColor))
                Spacer()
            }
            .padding(size.width * 0.1)
            
            RegistrationFormView(size: size, currentForm: $currentForm)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    
    @State var keyboardIsShowing = false
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
            keyboardIsShowing = false
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
            keyboardIsShowing = true
        }
    }
    

}

struct RegistrationFormView: View {
    
    @StateObject var userRegistrationViewModel = UserRegistrationViewModel()
    let size: CGSize
    
    
    var body: some View {
        ZStack {
            NavigationView {
                registrationForm1()
            }
        }
    }
    
    

    
    @Binding var currentForm: RegistrationForm?
    
    @State var email = ""
    
    let formPadding: CGFloat = 50
    let formSectionTitleColor = Styles.mainColor4
    
    
    func form1IsValid() -> Bool {
       !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    func registrationForm1() -> some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 80) {
                HStack {
                    Text("Email")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                        .foregroundColor(Color(formSectionTitleColor))
                        .padding(.top, formPadding)
                    Spacer()
                    
                }
                .padding(.bottom, 40)
                
                ZStack(alignment: .leading) {
                    if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("ilovecoffee@gmail.com")
                            .foregroundColor(Color(Styles.secondaryTextColor))
                            .italic()
                            .font(.custom(Styles.standardFontFamily, size: 20))
                            .offset(y: -5)
                            
                    }
                    TextField("Email", text: $email)
                        .inputTextFieldStyle()
                        .foregroundColor(Color(Styles.primaryTextColor))
                        .font(.custom(Styles.standardFontFamily, size: 20))
                }
                    
                NavigationLink(destination: registrationForm2()) {
                    RegistrationNextButtonView()
                }
                .opacity(form1IsValid() ? 1 : 0)
                .animation(.linear)
                
            }
            .padding(size.width * 0.1)
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    
    @State var phoneNumber = ""
    @State var selectingPhoneCountry = false
    @State var selectedPhoneCountryIndex = 1
    
    func form2IsValid() -> Bool {
        !phoneNumber.isEmpty
    }
    
    func registrationForm2() -> some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 80) {
                HStack {
                    Text("Phone Number")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                        .foregroundColor(Color(formSectionTitleColor))
                        .padding(.top, formPadding)
                    Spacer()
                    
                }
                .padding(.bottom, 40)
//                    HStack {
//                        Text(Country.allCases[selectedPhoneCountryIndex].rawValue)
//                            .font(.custom(Styles.standardFontFamily, size: 20))
//                            .foregroundColor(.white)
//                            .onTapGesture {
//                                withAnimation {
//                                    selectingPhoneCountry.toggle()
//                                }
//                            }
//                            .padding(.horizontal, 25)
//                            .padding(.vertical, 15)
//                            .overlay (
//                                RoundedRectangle(cornerRadius: 45)
//                                    .stroke(Color(Styles.mainColor3), lineWidth: 1)
//                            )
//                        Spacer()
//                    }
                
                ZStack(alignment: .leading) {
                    if phoneNumber.isEmpty {
                        Text("(123) 456-7890")
                            .foregroundColor(Color(Styles.secondaryTextColor))
                            .italic()
                            .font(.custom(Styles.standardFontFamily, size: 18))
                            .offset(y: -5)
                            
                    }
                    iPhoneNumberField("", text: $phoneNumber)
                        .foregroundColor(Color(Styles.primaryTextColor))
                        .inputTextFieldStyle()
                        
                        
                }
//                Group {
//                    if selectingPhoneCountry {
//                        Picker("Country", selection: $selectedPhoneCountryIndex) {
//                            ForEach(0..<Country.allCases.count) { index in
//                                Text(Country.allCases[index].rawValue)
//                                    .font(.custom(Styles.standardFontFamily, size: 20))
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .clipped()
//                    }
//                }
//                .onTapGesture {
//                    withAnimation {
//                        selectingPhoneCountry = false
//                    }
//                }
            
                
//                Button(action: { currentForm = .basic }) {
//                    RegistrationNextButtonView()
//                }
                NavigationLink(destination: registrationForm3()) {
                    RegistrationNextButtonView()
                }
                .opacity(form2IsValid() ? 1 : 0)
                .animation(.linear)
                
                
            }
            .padding(size.width * 0.1)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    @State var firstName = ""
    @State var lastName = ""
    @State var selectedCountryIndex = -1
    @State var birthday: Date = Date()
    
    
    //let countries = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    
    @State var selectingCountry = false
    
    func form3IsValid() -> Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            selectedCountryIndex > -1
    }

    
    func registrationForm3() -> some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: .leading, spacing: 75) {
                HStack {
                    Text("Basics")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                        .foregroundColor(Color(formSectionTitleColor))
                        .padding(.top, formPadding - 20)
                    Spacer()
                }
            
                
                BasicInfoTextField(label: "First name", text: $firstName)
                BasicInfoTextField(label: "Last name", text: $lastName)
                //BasicInfoTextField(label: "Birthday", text: $birthday)
                DatePicker("Birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                    .foregroundColor(Color(Styles.mainColor4))
                    .font(.custom(Styles.standardFontFamily, size: 20))
                    .accentColor(.white)
                VStack {
                    HStack {
                        Text(selectedCountryIndex == -1 ? "Country" : Country.allCases[selectedCountryIndex].rawValue)
                            .font(.custom(Styles.standardFontFamily, size: 20))
                            .foregroundColor(.white)
                            .onTapGesture {
                                withAnimation {
                                    selectingCountry.toggle()
                                }
                            }
                        Spacer()
                    }
                    .inputTextFieldStyle()
                    
                    
                    Group {
                        if selectingCountry {
                            Picker("Country", selection: $selectedCountryIndex) {
                                ForEach(0..<Country.allCases.count) { index in
                                    Text(Country.allCases[index].rawValue)
                                        .font(.custom(Styles.standardFontFamily, size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                            .clipped()
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectingCountry = false
                        }
                    }
                }
                
                
                NavigationLink(destination: registrationForm4()) {
                    RegistrationNextButtonView()
                }
                .opacity(form3IsValid() ? 1 : 0)
                .animation(.linear)
            }
            .padding(size.width * 0.1)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    
    

    
    func registrationForm4() -> some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 80) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Referral Code")
                            .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                            .foregroundColor(Color(formSectionTitleColor))
                            .padding(.top, formPadding)
                            .padding(.bottom)
                        Text("If your friend told you about us,\nenter their referral code here and they'll receive rewards after you finish signing up!")
                            .font(.custom(Styles.standardFontFamily, size: 18))
                            .foregroundColor(Color(Styles.mainColor5))
                    }
                    Spacer()
                    
                }
                
                
                
                ZStack(alignment: .leading) {
                    if userRegistrationViewModel.referralCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("x983...")
                            .foregroundColor(Color(Styles.secondaryTextColor))
                            .italic()
                            .font(.custom(Styles.standardFontFamily, size: 20))
                            .offset(y: -5)
                            
                    }
                    ZStack(alignment: .trailing) {
                        TextField("", text: $userRegistrationViewModel.referralCode, onCommit: {
                            // HANDLE REFERRAL CODE CHECK
                            userRegistrationViewModel.checkReferralCode()
                        })
                            .inputTextFieldStyle()
                            .foregroundColor(Color(Styles.primaryTextColor))
                            .font(.custom(Styles.standardFontFamily, size: 20))
                            Image(systemName: "checkmark.seal.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.green)
                                .padding(.bottom, 10)
                                .opacity(userRegistrationViewModel.validReferralCode ? 1 : 0).animation(.linear)
                        
                    }
                }
                    
                NavigationLink(destination: registrationForm5()) {
                    RegistrationNextButtonView()
                }
                
            }
            .padding(size.width * 0.1)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    @State var password = ""
    @State var confirmPassword = ""
    @State var username = ""
    
    private func form5IsValid() -> Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            password == confirmPassword && !password.isEmpty
    }
    
    func registrationForm5() -> some View {
        ZStack(alignment: .top) {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            VStack(spacing: 80) {
                HStack {
                    Text("Account")
                        .font(.custom(Styles.standardFontFamilyMedium, size: 40))
                        .foregroundColor(Color(formSectionTitleColor))
                        .padding(.top, formPadding)
                    Spacer()
                    
                }
                .padding(.bottom)
                
                BasicInfoTextField(label: "Username", text: $username)
                SecureTextField(label: "Password", text: $password)
                SecureTextField(label: "Confirm password", text: $confirmPassword)
                //BasicInfoTextField(label: "Password", text: $password)
                //BasicInfoTextField(label: "Confirm password", text: $confirmPassword)
                
                Button (action: {
                    createUser()
                    if form5IsValid() {
                        createUser()
                    }
                }) {
                    ButtonView(text: "Create")
                }
                .padding(.top)
                
                
            }
            .padding(size.width * 0.1)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func createUser() {
        let debug = false
        if debug {
            userRegistrationViewModel.addUserToDatabase(
                            email: UUID().uuidString + "@yahoo.com",
                            phoneNumber: phoneNumber,
                            firstName: "Shy",
                            lastName: "Martin",
                            birthday: Date(),
                            country: .Russia,
                            username: "shy_martin",
                            password:"password")
        }
        else {
            userRegistrationViewModel.addUserToDatabase(
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            phoneNumber: phoneNumber,
                            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                            birthday: birthday,
                            country: Country.allCases[selectedCountryIndex],
                            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                            password: password)
        }
    }
}







struct SecureTextField: View {
    var label: String
    @State var labelIsMinimized = false
    @Binding var text: String
    var formatter: Formatter?
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .font(.custom(Styles.standardFontFamily, size: labelIsMinimized ? 14 : 20))
                .foregroundColor(.white)
                .padding(.bottom)
                .offset(y: labelIsMinimized ? -35 : 2)
        
          
            SecureField("", text: $text) {
                withAnimation {
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        labelIsMinimized = false
                    }
                    else {
                        labelIsMinimized = true
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    if labelIsMinimized {
                        if text == "" {
                            labelIsMinimized = false
                        }
                    }
                    else {
                        labelIsMinimized = true
                    }
                }
            }
            .font(.custom(Styles.standardFontFamily, size: 20))
            .inputTextFieldStyle()
            .foregroundColor(Color(Styles.primaryTextColor))
        }
    }
}

struct BasicInfoTextField: View {
    var label: String
    @State var labelIsMinimized = false
    @Binding var text: String
    var formatter: Formatter?
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .font(.custom(Styles.standardFontFamily, size: labelIsMinimized ? 14 : 20))
                .foregroundColor(.white)
                .padding(.bottom)
                .offset(y: labelIsMinimized ? -35 : 2)
        
            TextField("", text: $text)
            { (_) in
                withAnimation {
                    labelIsMinimized = true
                }
            } onCommit: {
                withAnimation {
                    if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        labelIsMinimized = false
                    }
                    else {
                        labelIsMinimized = true
                    }
                }
            }
            .font(.custom(Styles.standardFontFamily, size: 20))
            .inputTextFieldStyle()
            .foregroundColor(Color(Styles.primaryTextColor))
        }
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1882458925, green: 0.1881759465, blue: 0.1925152242, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            RegisterView(showRegister: .constant(true))
        }
    }
}
