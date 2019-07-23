//
//  LocationError.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation

enum LocationError: Error {
    
    case error(error: Error)
    case authorization(error: String)
    
    var info: String {
        switch self {
        case .error(let error):
            return error.localizedDescription
        case .authorization(let value):
            return "Can't get user location current state: \(value)"
        }
    }
}
