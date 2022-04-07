//
//  AirQualityError.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import Foundation

enum AirQualityError: LocalizedError {
    
    case invalidURL(FetchType)
    case urlSessionError(FetchType, Error)
    case httpResponseStatusCode(FetchType, Int)  // Int is for statusCode
    case noData(FetchType)
    case unableToDecodeData(FetchType, Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let fetchType):
            return "Invalid URL for \(fetchType)."
        case .urlSessionError(let fetchType, let error):
            return "There was an error downloading \(fetchType) data: \(error.localizedDescription)"
        case .httpResponseStatusCode(let fetchType, let statusCode):
            return "The server responded to the \(fetchType) request with status code \(statusCode)."
        case .noData(let fetchType):
            return "There was no data returned for the \(fetchType) request."
        case .unableToDecodeData(let fetchType, let error):
            return "Unable to decode \(fetchType) data: \(error.localizedDescription)"
        }
    }
}
