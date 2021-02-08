//
//  ShopViewModel.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/24/21.
//

import Foundation
import UIKit

class ShopViewModel: ObservableObject {
    @Published var visibleShopItems: [Product] = []
    @Published var showProductDetailView: Bool = false
    @Published var selectedProduct: Product?
    
    init() {
        fetchProducts()
    }
    
    
    
    func fetchProducts() {
        let products_per_page = 10
        if let productsURL = URL(string: "https://api.hackathon.tchibo.com/api/v1/products?per_page=\(products_per_page)%22") {
            URLSession.shared.dataTask(with: productsURL) { (data, resp, err) in
                if let err = err {
                    print("Error fetching products: \(err.localizedDescription)")
                    return
                }
                if let data = data {
                    if let resp = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.parseProductFromRespData(resp)
                    }
                }
            }.resume()
        }
    }
    
    func parseProductFromRespData(_ resp: [String : Any]) {
        if let productsData = resp["data"] as? [[String : Any]] {
            productsData.forEach {
                do {
                    let productData =  try JSONDecoder().decode(ProductData.self, from: try JSONSerialization.data(withJSONObject: $0, options: []))
                    parseImageURLForProductWithData(productData, data: $0)
                    print(productData)
                    DispatchQueue.main.async {
                        self.visibleShopItems.append(Product(data: productData))
                    }
                }
                catch  {
                    print(error)
                }
            }
        }
    }
    
    private func parseImageURLForProductWithData(_ product: ProductData, data: [String:Any]) {
        
        if let imageResp = data["image"] as? [String : Any] {
            if let defaultImageURL = URL(string: imageResp["default"] as! String) {
                product.defaultImageURL = defaultImageURL
            }
            var galleryImageURLs = [URL]()
            if let galleryResp = imageResp["gallery"] as? [String] {
                galleryResp.forEach {
                    if let galleryImageURL = URL(string: $0) {
                        galleryImageURLs.append(galleryImageURL)
                    }
                }
            }
            product.galleryImageURLs = galleryImageURLs
        }
    }
    
    
    
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
