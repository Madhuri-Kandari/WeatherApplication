//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by M1066900 on 26/06/21.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var weatherSearchResults = [Daily]()
    
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.weatherCellViewModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell
        else{
            fatalError("cell with weatherCell view cell doesn't exist")
        }
        let weatherResultObject = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = weatherResultObject
        return cell
    }
}

extension WeatherTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty{
            searchBar.resignFirstResponder()
            weatherSearchResults = []
            tableView.reloadData()
            viewModel.getWeatherData(at: locationString)
        }
    }
}
