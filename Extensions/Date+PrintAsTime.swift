//
//  Date+PrintAsTime.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/31/21.
//

import Foundation

extension Date {
    func printAsTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: self)
    }
}
