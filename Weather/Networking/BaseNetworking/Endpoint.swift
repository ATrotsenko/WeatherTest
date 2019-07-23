//
//  Endpoint.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint {
    var url: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parametres: AnyDict? { get }
    var headers: Alamofire.HTTPHeaders? { get }
}

