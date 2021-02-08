//
//  IncompleteFieldMessage.swift
//  GreenerBox
//
//  Created by Linda Yeung on 11/29/20.
//

import SwiftUI

struct IncompleteFieldMessage: View {
    var showIncompleteFieldMessage: Bool
    
    var body: some View {
        Text("Please fill out all required fields!")
            .opacity(showIncompleteFieldMessage ? 1 : 0)
            .font(.custom(Styles.standardFontFamily, size: 18))
            .foregroundColor(Color.red)
            .offset(y: -10)
    }
}

struct IncompleteFieldMessage_Previews: PreviewProvider {
    static var previews: some View {
        IncompleteFieldMessage(showIncompleteFieldMessage: true)
    }
}
