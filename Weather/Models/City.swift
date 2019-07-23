//
//  City.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation

class City: Decodable {

    var id: Int
    var name: String
    var timezone: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case timezone
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        timezone = try container.decode(Int.self, forKey: .timezone)
    }
}
