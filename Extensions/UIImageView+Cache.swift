//
//  UIImageView+Cache.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/7/21.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageCache {
    func get(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: key))
    }
    
    func set(forKey key: String, image: UIImage) {
        imageCache.setObject(image, forKey: NSString(string: key))
    }
    
    static func getImageCache() -> NSCache<NSString, UIImage> { imageCache }
    
}


