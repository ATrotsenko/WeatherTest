//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

protocol WeatherViewModel {
    
    var cityName: String { get }
    var date: String { get }
    var hourTime: String { get }
    var dayName: String { get }
    var temp: String { get }
    var tempMax: String { get }
    var tempMin: String { get }
    var tempMinMax: String { get }
    var humidity: String { get }
    var windSpeed: String { get }
    var windDirectionIconName: String? { get }
    var weatherIconName: String? { get }
}

class WeatherViewModelImp: WeatherViewModel {
    
    var cityName: String
    var date: String
    var hourTime: String
    var dayName: String
    var temp: String
    var tempMax: String
    var tempMin: String
    var tempMinMax: String
    var humidity: String
    var windSpeed: String
    var windDirectionIconName: String?
    var weatherIconName: String?
    
    init(city: City, hour: Hour) {
        cityName = city.name
        date = Date(timeIntervalSince1970: hour.timeInterval).string(.dayTime)
        hourTime = Date(timeIntervalSince1970: hour.timeInterval).string(.hourTime)
        dayName = Date(timeIntervalSince1970: hour.timeInterval).string(.dayName)
        temp = hour.main.temp.toTemperatureString
        tempMax = hour.main.tempMax.toTemperatureString
        tempMin = hour.main.tempMin.toTemperatureString
        tempMinMax = tempMax + "/" + tempMin
        humidity = "\(hour.main.humidity)%"
        windSpeed = "\(Int(hour.wind.speed.rounded()))m/s"
        windDirectionIconName = WindDirection(double: hour.wind.degree)?.iconName
        weatherIconName = WeatherIcon.iconName(weaterType: hour.weather.first!.icon)
    }
}

fileprivate enum WindDirection: String {
    case e, n, ne, s, se, w, wn, ws
    
    init?(double: Double) {
        switch double {
        case 337.5...: self = .n
        case 292.5..<337.5: self = .wn
        case 247.5..<292.5: self = .w
        case 202.5..<247.5: self = .ws
        case 157.5..<202.5: self = .s
        case 122.5..<157.5: self = .se
        case 67.5..<122.5:  self = .e
        case 22.5..<67.5:   self = .ne
        default: self = .n
        }
    }
    
    var iconName: String {
        return String(format: "icon_wind_%@", self.rawValue)
    }
}

fileprivate struct WeatherIcon {
    static func iconName(weaterType: WeatherDesc.Icon) -> String? {
        switch weaterType {
        case .dayBright:  return "ic_white_day_bright"
        case .dayCloudy: return "ic_white_day_cloudy"
        case .dayRain: return "ic_white_day_rain"
        case .dayShower: return "ic_white_day_shower"
        case .dayThunder: return "ic_white_day_thunder"
        case .nightBright: return "ic_white_night_bright"
        case .nightCloudy: return "ic_white_night_cloudy"
        case .nightRain: return "ic_white_night_rain"
        case .nightShower: return "ic_white_night_shower"
        case .nightThunder: return "ic_white_night_thunder"
        default: return nil
        }
    }
}

fileprivate extension Double {
    var toTemperatureString: String {
        return "\(Int(self.rounded()))°"
    }
}
