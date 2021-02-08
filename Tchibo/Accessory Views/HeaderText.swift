//
//  HeaderText.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import SwiftUI

struct HeaderText: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom(Styles.standardFontFamily, size: 34))
                .bold()
                .foregroundColor(Color(Styles.mainColor3))
            Spacer()
        }
    }
}

struct HeaderText_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
                .edgesIgnoringSafeArea(.all)
            HeaderText(text: "Add New Friend")
        }
    }
}
