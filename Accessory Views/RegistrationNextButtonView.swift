//
//  RegistrationNextButtonView.swift
//  GreenerBox
//
//  Created by Linda Yeung on 11/15/20.
//

import SwiftUI

struct RegistrationNextButtonView: View {
    var body: some View {
        HStack(spacing: 15) {
            Spacer()
            Image(systemName: "arrow.right")
                .resizable()
                .frame(width: 30, height: 23)
        }
        .foregroundColor(Color(Styles.mainColor2))
    }
}

struct RegistrationNextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationNextButtonView()
    }
}
