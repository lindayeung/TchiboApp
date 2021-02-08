//
//  Float+AsStringWithDecimalPlaces.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import Foundation

extension Float {
    func asStringWithDecimalPlaces(_ places: Int) -> String {
        String(format: "%.\(places)f", self)
    }
}
