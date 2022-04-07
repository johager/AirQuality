//
//  FetchType.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import Foundation

enum FetchType: String {
    case countries
    case states
    case cities
    case aqForCity
    
    var endpoint: String {
        switch self {
        case .aqForCity:
            return "city"
        default:
            return rawValue
        }
    }
}
