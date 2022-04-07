//
//  StateListViewController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class StateListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var countryName: String?
    
    var stateNames = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let countryName = countryName {
            title = countryName
        }
        
        fetchStates()
    }
    
    // MARK: - Helper Functions
    
    func fetchStates() {
        guard let countryName = countryName else { return }
        
        AirQualityController.fetchStates(forCountry: countryName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stateNames):
                    self.stateNames = stateNames
                case .failure(let error):
                    print("\(#function) - error: \(error)")
                    self.presentErrorAlert(for: error)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showCities",
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? CityListViewController
        else { return }
        destination.countryName = countryName
        destination.stateName = stateNames[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension StateListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = stateNames[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}
