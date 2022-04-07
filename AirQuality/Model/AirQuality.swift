//
//  AirQuality.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import Foundation

// MARK: - Country

struct CountryData: Decodable {
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countries = "data"
    }
}

struct Country: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "country"
    }
}

// MARK: - State

struct StateData: Decodable {
    let states: [State]
    
    enum CodingKeys: String, CodingKey {
        case states = "data"
    }
}

struct State: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "state"
    }
}

// MARK: - City

struct CityData: Decodable {
    let cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities = "data"
    }
}

struct City: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "city"
    }
}

// MARK: - AQ

struct AQCityData: Decodable {
    let aqData: AQData
    
    enum CodingKeys: String, CodingKey {
        case aqData = "data"
    }
}

struct AQData: Decodable {
    let city: String
    let state: String
    let country: String
    let location: AQLocation
    let current: AQCurrent
}

struct AQLocation: Decodable {
    let coordinates: [Double]
    
    var lat: Double? {
        guard coordinates.count == 2 else { return nil }
        return coordinates[1]
    }
    
    var lon: Double? {
        guard coordinates.count == 2 else { return nil }
        return coordinates[0]
    }
}

struct AQCurrent: Decodable {
    let weather: AQWeather
    let pollution: AQPollution
}

struct AQWeather: Decodable {
    let temp: Int
    let humidity: Int
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "tp"
        case humidity = "hu"
        case windSpeed = "ws"
    }
}

struct AQPollution: Decodable {
    let aqius: Int
}
