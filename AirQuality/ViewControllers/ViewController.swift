//
//  ViewController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        AirQualityController.fetchCountries { result in
//            print("completed")
//            switch result {
//            case .success(let countryNames):
//                print("\(#function) - countryNames: \(countryNames)")
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        AirQualityController.fetchStates(forCountry: "USA") { result in
//            print("completed")
//            switch result {
//            case .success(let stateNames):
//                print("\(#function) - stateNames: \(stateNames)")
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        AirQualityController.fetchCities(forCountry: "USA", state: "Utah") { result in
//            print("completed")
//            switch result {
//            case .success(let cityNames):
//                print("\(#function) - cityNames: \(cityNames)")
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        AirQualityController.fetchAQData(forCountry: "USA", state: "Utah", city: "Sandy") { result in
            print("completed")
            switch result {
            case .success(let aqData):
                print("\(#function) - aqData: \(aqData)")
            case .failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
