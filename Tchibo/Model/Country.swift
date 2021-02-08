//
//  Country.swift
//  Tchibo
//
//  Created by Linda Yeung on 2/5/21.
//

import Foundation

enum Country: String, Codable, CaseIterable {
    case UnitedStates = "United States"
    case Canada
    case Czechia
    case SaudiArabia = "Saudi Arabia"
    case Slovakia
    case Slovenia
    case Bulgaria
    case Romania
    case Turkey
    case Hungary
    case Ukraine
    case Syria
    case Israel
    case Jordan
    case Russia
    case UnitedArabEmirates = "United Arab Emirates"
    case Poland
    case Ireland
    case UnitedKingdom = "United Kingdom"
    case Switzerland
    case Liechtenstein
    case Lebano
    
    func flag() -> String {
        switch self {
        case .UnitedStates: return "🇺🇸"
        case .Canada: return "🇨🇦"
        case .Czechia: return "🇨🇿"
        case .SaudiArabia: return "🇸🇦"
        case .Slovakia: return "🇸🇰"
        case .Slovenia: return "🇸🇮"
        case .Bulgaria: return "🇧🇬"
        case .Romania: return "🇷🇴"
        case .Turkey: return "🇹🇷"
        case .Hungary: return "🇭🇺"
        case .Ukraine: return "🇺🇦"
        case .Syria: return "🇸🇾"
        case .Israel: return "🇮🇱"
        case .Jordan: return "🇯🇴"
        case .Russia: return "🇷🇺"
        case .UnitedArabEmirates: return "🇦🇪"
        case .Poland: return "🇵🇱"
        case .Ireland: return "🇮🇪"
        case .UnitedKingdom: return "🇬🇧"
        case .Switzerland: return "🇨🇭"
        case .Liechtenstein: return "🇱🇮"
        case .Lebano: return "🇱🇧"
        }
    }
    
    
}
