//
//  AirQualityController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import Foundation

class AirQualityController {
    
    // MARK: - Constants
    
    private static let baseURL = URL(string: "https://api.airvisual.com/v2/")
    
    private static let apiKeyKey = "key"
    private static let countryKey = "country"
    private static let stateKey = "state"
    private static let cityKey = "city"
    
    private static var apiKeyValue: String {
        let fileName = "AirVisual-Info"
        
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "plist")
        else { fatalError("Could not find the file '\(fileName)'") }
        
        do {
            let plistData = try Data(contentsOf: filePath)
            
            guard let dict = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any]
            else { fatalError("Could not decode the '\(fileName).plist' file.") }
            
            guard let apiKey = dict["API Key"] as? String
            else { fatalError("The '\(fileName).plist' file does not contain an API Key.") }
            
            if apiKey.hasPrefix("_") {
                fatalError("Install an API Key in the '\(fileName).plist' file.")
            }
            
            print("apiKey: '\(apiKey)'")
            return apiKey
        } catch {
            fatalError("Error reding the plist file: \(error), \(error.localizedDescription)")
        }
    }
    
    // MARK: - Methods
    
    // http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    
    static func fetchCountries(completion: @escaping (Result<[String], AirQualityError>) -> Void) {
        let fetchType: FetchType = .countries
        
        guard var url = baseURL else { return completion(.failure(.invalidURL(fetchType)))}
        url.appendPathComponent(fetchType.endpoint)
        
        let queryItems = [
            apiKeyKey: apiKeyValue
        ]
     
        guard let finalURL = makeURL(from: url, withQueryItems: queryItems) else { return }
        
        print("\(#function) - finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(fetchType, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(fetchType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(fetchType)))}
            
            do {
                let countryData = try JSONDecoder().decode(CountryData.self, from: data)
                let countryNames = countryData.countries.map { $0.name }
                return completion(.success(countryNames))
            } catch {
                completion(.failure(.unableToDecodeData(fetchType, error)))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    
    static func fetchStates(forCountry country: String, completion: @escaping (Result<[String], AirQualityError>) -> Void) {
        let fetchType: FetchType = .states
        
        guard var url = baseURL else { return completion(.failure(.invalidURL(fetchType)))}
        url.appendPathComponent(fetchType.endpoint)
        
        let queryItems = [
            countryKey: country,
            apiKeyKey: apiKeyValue
        ]
        
        guard let finalURL = makeURL(from: url, withQueryItems: queryItems) else { return }
        
        print("\(#function) - finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(fetchType, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(fetchType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(fetchType)))}
            
            do {
                let stateData = try JSONDecoder().decode(StateData.self, from: data)
                let stateNames = stateData.states.map { $0.name }
                return completion(.success(stateNames))
            } catch {
                completion(.failure(.unableToDecodeData(fetchType, error)))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    
    static func fetchCities(forCountry country: String, state: String, completion: @escaping (Result<[String], AirQualityError>) -> Void) {
        let fetchType: FetchType = .cities
        
        guard var url = baseURL else { return completion(.failure(.invalidURL(fetchType)))}
        url.appendPathComponent(fetchType.endpoint)
        
        let queryItems = [
            countryKey: country,
            stateKey: state,
            apiKeyKey: apiKeyValue
        ]
        
        guard let finalURL = makeURL(from: url, withQueryItems: queryItems) else { return }
        
        print("\(#function) - finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(fetchType, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(fetchType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(fetchType)))}
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                let cityNames = cityData.cities.map { $0.name }
                return completion(.success(cityNames))
            } catch {
                completion(.failure(.unableToDecodeData(fetchType, error)))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    
    static func fetchAQData(forCountry country: String, state: String, city: String, completion: @escaping (Result<AQData, AirQualityError>) -> Void) {
        let fetchType: FetchType = .aqForCity
        
        guard var url = baseURL else { return completion(.failure(.invalidURL(fetchType)))}
        url.appendPathComponent(fetchType.endpoint)
        
        let queryItems = [
            countryKey: country,
            stateKey: state,
            cityKey: city,
            apiKeyKey: apiKeyValue
        ]
        
        guard let finalURL = makeURL(from: url, withQueryItems: queryItems) else { return }
        
        print("\(#function) - finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                return completion(.failure(.urlSessionError(fetchType, error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.httpResponseStatusCode(fetchType, response.statusCode)))
                }
            }
            
            guard let data = data else { return completion(.failure(.noData(fetchType)))}
            
            do {
                let aqCityData = try JSONDecoder().decode(AQCityData.self, from: data)
                return completion(.success(aqCityData.aqData))
            } catch {
                completion(.failure(.unableToDecodeData(fetchType, error)))
            }
        }.resume()
    }
    
    static func makeURL(from url: URL, withQueryItems queryItems: [String: String]) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
        return components?.url
    }
}
