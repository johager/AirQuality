//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class CityDataViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLonLabel: UILabel!
    
    // MARK: - Properties
    
    var countryName: String?
    var stateName: String?
    var cityName: String?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAQData()
    }
    
    // MARK: - Helper Functions
    
    func fetchAQData() {
        guard let countryName = countryName,
              let stateName = stateName,
              let cityName = cityName
        else { return }
        
        AirQualityController.fetchAQData(forCountry: countryName, state: stateName, city: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let aqData):
                    self.updateViews(for: aqData)
                case .failure(let error):
                    print("\(#function) - error: \(error)")
                    self.presentErrorAlert(for: error)
                }
            }
        }
    }
    
    func updateViews(for aqData: AQData) {        
        cityStateCountryLabel.text = "\(aqData.city), \(aqData.state), \(aqData.country)"
        aqiLabel.text = "AQI: \(aqData.current.pollution.aqius)"
        windSpeedLabel.text = "Wind Speed: \(Int(round(aqData.current.weather.windSpeed * 2.23694))) mph"  // converted from meters-per-sec
        
        let tempF = Int(round((Double(aqData.current.weather.temp) * 9 / 5) + 32))  // convert °C to °F then round
        temperatureLabel.text = "Temperature: \(tempF)°F"
        humidityLabel.text = "Humidity: \(aqData.current.weather.humidity)%"
        
        if let lat = aqData.location.lat, let lon = aqData.location.lon {
            let latString = String(format: "%.2f", lat)  // display w/2 decimals
            let lonString = String(format: "%.2f", lon)
            latLonLabel.text = "Lat, lon: \(latString), \(lonString)"
        } else {
            latLonLabel.text = "Lat, lon: NA"
        }
    }
}
