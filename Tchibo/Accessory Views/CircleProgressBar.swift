//
//  CircleProgressBar.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/30/21.
//

import SwiftUI

struct CircleProgressBar: View {
    var progress: Float
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.black)
             
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(Styles.mainColor4))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeIn(duration: 1))
            
            Text("$" + (progress*100).asStringWithDecimalPlaces(2))
                .font(.custom(Styles.standardFontFamily, size: 30))
                .foregroundColor(Color(Styles.mainColor4))
                .bold()
            
        }
    }
}

struct CircleProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(Styles.primaryBackgroundColor)
            CircleProgressBar(progress: 0.4)
        }
    }
}
