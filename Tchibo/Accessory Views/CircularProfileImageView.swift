//
//  CircularProfileImageView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/29/21.
//

import SwiftUI

struct CircularProfileImageView: View {
    var uiImage: UIImage
    var size: CGFloat

    var body: some View {
        Circle()
            .fill(Color(Styles.mainColor4))
            .frame(width: size, height: size)
            .overlay(
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle()).padding(2)
            )
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(uiImage: UserProfile.sampleUser.profileImage()!, size: 40)
    }
}
