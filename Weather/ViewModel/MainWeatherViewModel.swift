//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import CoreLocation

class MainWeatherViewModel {
    
    private let weatherApi: WeatherAPI
    private let locationManager: LocationProvider
    
    private weak var view: MainWeatherView?
    private var weatherHours = [WeatherViewModel]()
    
    var selected: WeatherViewModel?

    // MARK: - Init
    init(weatherApi: WeatherAPI, locationManager: LocationProvider) {
        self.weatherApi = weatherApi
        self.locationManager = locationManager
    }
    
    // MARK: -  Action
    func getWeather(coordinates: CLLocationCoordinate2D?) {
        if let coordinates = coordinates {
            updateWeather(coord: coordinates)
        } else {
            updateFromUserCoordinates()
        }
    }
    
    private func updateFromUserCoordinates() {
        locationManager.getUserLocation { (coordinates, error) in
            if coordinates == nil, error != nil { return }
            self.updateWeather(coord: coordinates!)
        }
    }
    
    func connect(to view: MainWeatherView) {
        self.view = view
    }
    
    // MARK: - Data
    func selectedWeather() -> WeatherViewModel? {
        return selected
    }
    
    func hoursCount() -> Int {
        return weatherHours.count
    }
    
    func weather(indexPath: IndexPath) -> WeatherViewModel {
        return weatherHours[indexPath.row]
    }
    
    // MARK: - Server request
    private func updateWeather(coord: CLLocationCoordinate2D) {
        
        weatherApi.getWeatherCity(lat: coord.latitude, lon: coord.longitude) { (object, error) in
            
            if error != nil {
                return
            }
            
            guard let object = object else { return }
            self.weatherHours = object.list.map{ WeatherViewModelImp(city: object.city, hour: $0) }
            self.selected = self.weatherHours.first
            DispatchQueue.main.async {
                self.view?.reload()
            }
        }
    }
}
