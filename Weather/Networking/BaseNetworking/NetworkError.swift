//
//  NetworkError.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    static let errorKey = "error"
    
    case error(error: Error)
    case generic(description: String?)
    case status(code: Int)
    case failedSerialization
    case undefined
    
    var info: String {
        switch self {
        case .error(let error):
            return error.localizedDescription
        case .generic(let value):
            return value ?? ""
        case .status(_):
            return ""
        case .failedSerialization:
            return ""
        case .undefined:
            return ""
        }
    }
}
