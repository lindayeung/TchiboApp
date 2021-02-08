//
//  ProductView.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/27/21.
//

import SwiftUI

struct ProductCardView: View {
    @ObservedObject var product: Product = Product.sampleProduct
    
    let bounds = UIScreen.main.bounds
    
    var body: some View {
        HStack {
            if product.defaultImage != nil {
                Image(uiImage: product.defaultImage!)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            else {
                // Handle image loading
                Color.gray
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.data.title!)
                    .fontWeight(.bold)
                    .font(.custom(Styles.standardFontFamily, size: 20))
                    .foregroundColor(Color(Styles.mainColor3))
                Text(product.data.defaultDescription!)
                    .font(.custom(Styles.standardFontFamily, size: 16))
                    .foregroundColor(Color.white)
            }
            .padding(.leading)
            
        }
        .frame(height: bounds.height * 0.2, alignment: .leading)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardView()
    }
}
