//
//  ButtonView.swift
//  GreenerBox
//
//  Created by Linda Yeung on 11/15/20.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var width: CGFloat = 200
    var height: CGFloat = 50
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(LinearGradient(gradient: Gradient(colors:
                                                            [Color(Styles.mainColor2),
                                                             Color(Styles.mainColor3),
                                                            ]),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: width)
                .frame(height: height)
            Text(text)
                .font(.custom(Styles.standardFontFamilyMedium, size: 18))
                .foregroundColor(Color.white)
                .padding(.vertical)
                .padding(.horizontal, 25)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1882458925, green: 0.1881759465, blue: 0.1925152242, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            ButtonView(text: "Log in")
        }
    }
}
