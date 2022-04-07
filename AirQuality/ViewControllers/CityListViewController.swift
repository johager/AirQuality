//
//  CityListViewController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class CityListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var countryName: String?
    var stateName: String?
    
    var cityNames = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stateName = stateName {
            title = stateName
        }
        
        fetchCities()
    }
    
    // MARK: - Helper Functions
    
    func fetchCities() {
        guard let countryName = countryName,
              let stateName = stateName
        else { return }
        
        AirQualityController.fetchCities(forCountry: countryName, state: stateName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityNames):
                    self.cityNames = cityNames
                case .failure(let error):
                    print("\(#function) - error: \(error)")
                    self.presentErrorAlert(for: error)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showCityData",
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? CityDataViewController
        else { return }
        destination.countryName = countryName
        destination.stateName = stateName
        destination.cityName = cityNames[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension CityListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = cityNames[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}
