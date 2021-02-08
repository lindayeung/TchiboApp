//
//  StatusBarView.swift
//  GreenerBox
//
//  Created by Linda Yeung on 10/2/20.
//

import SwiftUI

struct TopStatusBarView: View {
    var geometry: GeometryProxy
    
    var body: some View {
        Color(Styles.primaryBackgroundColor)
        .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct BottomStatusBarView: View {
    var geometry: GeometryProxy
    
    var body: some View {
        Color(Styles.mainColor3)
            .frame(width: geometry.size.width, height: geometry.safeAreaInsets.bottom)
            .edgesIgnoringSafeArea(.bottom)
    }
}

