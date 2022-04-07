//
//  CountryListViewController.swift
//  AirQuality
//
//  Created by James Hager on 4/7/22.
//

import UIKit

class CountryListViewController: UITableViewController {

    // MARK: - Properties
    
    var countryNames = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
    // MARK: - Helper Functions
    
    func fetchCountries() {
        AirQualityController.fetchCountries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countryNames):
                    self.countryNames = countryNames
                case .failure(let error):
                    print("\(#function) - error: \(error)")
                    self.presentErrorAlert(for: error)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showStates",
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? StateListViewController
        else { return }
        destination.countryName = countryNames[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension CountryListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = countryNames[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}
