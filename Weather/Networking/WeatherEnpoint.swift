//
//  WeatherEnpoint.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let baseURL: URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast")!

enum WeatherEnpoint: Endpoint {
    
    case weatherDailyLocation(lat: Double, lon: Double)
    
    var url: URL {
        switch self {
        case .weatherDailyLocation(lat: let lat, lon: let lon):
            return destinationURL(options: ["lat": lat, "lon": lon, "units" : "metric"])
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var parametres: AnyDict? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

extension WeatherEnpoint {
    func destinationURL(options: AnyDict) -> URL {
        var options = options
        options["appid"] = openWeatherMapAPIKey
        return generateGetRequest(baseURL, options: options)!
    }

    private func generateGetRequest(_ url: URL, options: AnyDict) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { fatalError("GET String error") }
        
        urlComponents.queryItems = []
        for (key, value) in options {
            if let value = value as? [Any] {
                value.forEach{
                    urlComponents.queryItems!.append(URLQueryItem(name: key + "[]", value: "\($0)"))
                }
            } else {
                urlComponents.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        return urlComponents.url
    }
}
