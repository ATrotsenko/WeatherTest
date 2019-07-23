//
//  Weather.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation

class Weather: Decodable {
    
    var city: City
    var list: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case city
        case list
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(City.self, forKey: .city)
        list = try container.decode([Hour].self, forKey: .list)
    }
}

