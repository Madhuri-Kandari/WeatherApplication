//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by M1066900 on 27/07/21.
//

import UIKit
import CoreLocation

class WeatherViewModel: NSObject {

    var weatherData = [Daily]()
    
    var weatherCellViewModels = [WeatherCellViewModel](){
        didSet{
            refreshTableView?()
        }
    }
    
    let weatherTabVC = WeatherTableViewController()
    
    var dataTask:URLSessionDataTask?
    var refreshTableView: (()->Void)?
    
    func getCellViewModel(at indexPath:IndexPath)->WeatherCellViewModel{
        return weatherCellViewModels[indexPath.section]
    }
    
    func createCellModel(weather:Daily)->WeatherCellViewModel{
        let clouds = "Clouds: \(weather.clouds)"
        let temperature = "Temparature: \(weather.temp.max) F"
        let description =  weather.weather[0].description
        return WeatherCellViewModel(clouds: clouds, temperature: temperature, description: description)
    }
    
    func weatherApiURL(location: CLLocationCoordinate2D)->URL{
        let URL_BASE = "https://api.openweathermap.org/data/2.5"
        let URL_API_KEY = "c8bfa91e3d6c7ae47771abaa83ee73b7"
        let URL_LATITUDE = "\(location.latitude)"
        let URL_LONGITUDE = "\(location.longitude)"
        var URL_GET_ONE_CALL = ""
        URL_GET_ONE_CALL = "/onecall?lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=imperial" + "&appid=" + URL_API_KEY
        let urlString = URL_BASE + URL_GET_ONE_CALL
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(data:Data)->[Daily]{
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: data)
            return result.daily
        }catch{
            print("JSON error: \(error)")
            return []
        }
    }
    
    func fetchData(weatherData:[Daily]){
        self.weatherData = weatherData
        var viewModels = [WeatherCellViewModel]()
        for weather in weatherData{
            viewModels.append(createCellModel(weather: weather))
        }
        weatherCellViewModels = viewModels
        DispatchQueue.main.async {
            self.weatherTabVC.tableView.reloadData()
        }
        print(weatherCellViewModels)
    }
    
    func getWeatherData(at locationString:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString){ (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil{
                if let location = placemarks?.first?.location{
                    let url = self.weatherApiURL(location: location.coordinate)
                    let session = URLSession.shared
                    self.dataTask = session.dataTask(with: url){data, response, error in
                        if let error = error{
                            print("Failure! \(error.localizedDescription)")
                        }else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
                            if let data = data{
                                self.weatherData = self.parse(data: data)
                                self.fetchData(weatherData: self.weatherData)
                                return
                            }
                        }else{
                            print("Fails \(String(describing: response))")
                        }
                        DispatchQueue.main.async {
                            self.weatherTabVC.tableView.reloadData()
                        }                    }
                    self.dataTask?.resume()
                }
            }
    }

    func showNetworkError(){
        let alert = UIAlertController(title: "Error", message: "Error in accessing the server, please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        weatherTabVC.present(alert, animated: true, completion: nil)
    }
    
}
}
