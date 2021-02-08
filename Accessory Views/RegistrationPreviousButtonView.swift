//
//  RegistrationPreviousButtonView.swift
//  GreenerBox
//
//  Created by Linda Yeung on 11/15/20.
//

import SwiftUI

struct RegistrationPreviousButtonView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 10, height: 20)
            
            Text("Prev")
                .font(.custom(Styles.standardFontFamily, size: 18))
        }
        .foregroundColor(Color(Styles.mainColor1))
    }
}

struct RegistrationPreviousButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPreviousButtonView()
    }
}
