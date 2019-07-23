//
//  WeatherAPI.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import Alamofire

typealias WeatherResponse = (_ days: Weather?, _ error: NetworkError?) -> Void

protocol WeatherAPI: class {
    @discardableResult func getWeatherCity(lat: Double, lon: Double, completion: WeatherResponse?) -> Request?
}

class WeatherAPIImpl: WeatherAPI {
    
    let networkLayer: BaseNetworkLayer
    
    init(networkLayer: BaseNetworkLayer) {
        self.networkLayer = networkLayer
    }
}

extension WeatherAPIImpl {
    @discardableResult func getWeatherCity(lat: Double, lon: Double, completion: WeatherResponse?) -> Request? {
        let endPoint = WeatherEnpoint.weatherDailyLocation(lat: lat, lon: lon)
        return self.networkLayer.objectRequest(endPoint: endPoint) { (_, result: Weather?, error) in
            completion?(result, error)
        }
    }
}
