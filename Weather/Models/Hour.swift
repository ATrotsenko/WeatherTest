//
//  Hour.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation

class Hour: Decodable {
    
    var timeInterval: TimeInterval
    var date: String
    var main: Main
    var wind: Wind
    var weather: [WeatherDesc]

    
    enum CodingKeys: String, CodingKey {
        case timeInterval = "dt"
        case date = "dt_txt"
        case main
        case wind
        case weather
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timeInterval = try container.decode(TimeInterval.self, forKey: .timeInterval)
        date = try container.decode(String.self, forKey: .date)
        main = try container.decode(Main.self, forKey: .main)
        wind = try container.decode(Wind.self, forKey: .wind)
        weather = try container.decode([WeatherDesc].self, forKey: .weather)
    }
}

class Main: Decodable {
    
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity = "humidity"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        tempMin = try container.decode(Double.self, forKey: .tempMin)
        tempMax = try container.decode(Double.self, forKey: .tempMax)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }
}

class Wind: Decodable {
    
    var speed: Double
    var degree: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Double.self, forKey: .speed)
        degree = try container.decode(Double.self, forKey: .degree)
    }
}

class Weatherwind: Decodable {
    
    var speed: Double
    var degree: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Double.self, forKey: .speed)
        degree = try container.decode(Double.self, forKey: .degree)
    }
}

class WeatherDesc: Decodable {
    
    enum Icon: Decodable {
        case dayBright
        case dayCloudy
        case dayRain
        case dayShower
        case dayThunder
        case nightBright
        case nightCloudy
        case nightRain
        case nightShower
        case nightThunder
        case other
        
        init(from decoder: Decoder) throws {
            let label = try decoder.singleValueContainer().decode(String.self)
            switch label {
            case "01d": self = .dayBright
            case "02d", "03d", "04d": self = .dayCloudy
            case "10d": self = .dayRain
            case "09d": self = .dayShower
            case "11d": self = .dayThunder
            case "01n": self = .nightBright
            case "02n", "03n", "04n": self = .nightCloudy
            case "10n": self = .nightRain
            case "09n": self = .nightShower
            case "11n": self = .nightThunder
            default: self = .other
            }
        }
    }
    
    var id: Int
    var main: String
    var desc: String
    var icon: Icon
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        desc = try container.decode(String.self, forKey: .description)
        icon = try container.decode(Icon.self, forKey: .icon)
    }
}


