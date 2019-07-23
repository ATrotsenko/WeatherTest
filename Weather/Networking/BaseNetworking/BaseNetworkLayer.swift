//
//  BaseNetworkLayer.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONResponse = (_ responce: HTTPURLResponse?, _ result: AnyDict?, _ error: NetworkError?) -> Void
typealias JSONsResponse = (_ responce: HTTPURLResponse?, _ result: [AnyDict]?, _ error: NetworkError?) -> Void

protocol BaseNetworkLayer {
    @discardableResult func jsonRequest(request: URLRequestConvertible, queue: DispatchQueue, completion: JSONResponse?) -> Request?
    @discardableResult func jsonsRequest(request: URLRequestConvertible, queue: DispatchQueue, completion: JSONsResponse?) -> Request?
    
    @discardableResult func jsonRequest(url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, queue: DispatchQueue, completion: JSONResponse?) -> Request?
    
    @discardableResult func jsonsRequest(url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, queue: DispatchQueue, completion: JSONsResponse?) -> Request?
    
    @discardableResult func jsonRequest(endPoint: Endpoint, queue: DispatchQueue, completion: JSONResponse?) -> Request?
    @discardableResult func jsonsRequest(endPoint: Endpoint, queue: DispatchQueue, completion: JSONsResponse?) -> Request?
    
    @discardableResult func objectRequest<T: Decodable>(endPoint: Endpoint,
                                                      completion: @escaping (_ responce: HTTPURLResponse?, _ object: T?, _ error: NetworkError?) -> Void) -> Request?
    
    @discardableResult func objectsRequest<T: Decodable>(endPoint: Endpoint,
                                                       completion: @escaping (_ responce: HTTPURLResponse?, _ object: [T]?, _ error: NetworkError?) -> Void) -> Request?
}

class BaseNetworkLayerImpl {
    let sessionManager: SessionManager
    
    init(sessionManager: SessionManager = Alamofire.SessionManager()) {
        self.sessionManager = sessionManager
    }
}

extension BaseNetworkLayerImpl: BaseNetworkLayer {
    func jsonRequest(request: URLRequestConvertible, queue: DispatchQueue, completion: JSONResponse?) -> Request? {
        let task = self.sessionManager.request(request)
        return self.performJSON(task: task, queue: queue, completion: completion)
    }
    
    func jsonsRequest(request: URLRequestConvertible, queue: DispatchQueue, completion: JSONsResponse?) -> Request? {
        let task = self.sessionManager.request(request)
        return self.performJSONs(task: task, queue: queue, completion: completion)
    }
    
    func jsonRequest(url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, queue: DispatchQueue, completion: JSONResponse?) -> Request? {
        let task = self.sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        return self.performJSON(task: task, queue: queue, completion: completion)
    }
    
    func jsonsRequest(url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, queue: DispatchQueue, completion: JSONsResponse?) -> Request? {
        let task = self.sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        return self.performJSONs(task: task, queue: queue, completion: completion)
    }
    
    func jsonRequest(endPoint: Endpoint, queue: DispatchQueue, completion: JSONResponse?) -> Request? {
        return jsonRequest(url: endPoint.url, method: endPoint.method, parameters: endPoint.parametres, encoding: endPoint.encoding, headers: endPoint.headers, queue: queue, completion: completion)
    }
    
    func jsonsRequest(endPoint: Endpoint, queue: DispatchQueue, completion: JSONsResponse?) -> Request? {
        return jsonsRequest(url: endPoint.url, method: endPoint.method, parameters: endPoint.parametres, encoding: endPoint.encoding, headers: endPoint.headers, queue: queue, completion: completion)
    }
    
    func objectRequest<T: Decodable>(endPoint: Endpoint,
                                   completion: @escaping (_ responce: HTTPURLResponse?, _ object: T?, _ error: NetworkError?) -> Void) -> Request?
    {
        let processQueue = DispatchQueue.global(qos: .background)
        return self.jsonRequest(endPoint: endPoint, queue: processQueue) { (responce, result, error) in
            guard let json = result else {
                completion(responce, nil, error)
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let object = try JSONDecoder().decode(T.self, from: data)
                
                completion(responce, object, nil)
            } catch let error {
                completion(responce, nil, NetworkError.error(error: error))
            }
        }
    }
    
    func objectsRequest<T: Decodable>(endPoint: Endpoint,
                                    completion: @escaping (_ responce: HTTPURLResponse?, _ objects: [T]?, _ error: NetworkError?) -> Void) -> Request?
    {
        let processQueue = DispatchQueue.global(qos: .background)
        return self.jsonsRequest(endPoint: endPoint, queue: processQueue) { (responce, result, error) in
            guard let jsons = result else {
                completion(responce, nil, error)
                return
            }
            
            do {
                let objects = try jsons.compactMap({ (json) -> T? in
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    return try JSONDecoder().decode(T.self, from: data)
                })
                
                completion(responce, objects, nil)
            } catch let error {
                completion(responce, nil, NetworkError.error(error: error))
            }
        }
    }
}

private extension BaseNetworkLayerImpl {
    @discardableResult func performJSON(task: DataRequest?, queue: DispatchQueue, completion: JSONResponse?) -> Request? {
        guard let task = task else {
            let errorMessage = "Expect sessionManager should return DataTask"
            assertionFailure(errorMessage)
            completion?(nil, nil, .generic(description: errorMessage))
            
            return nil
        }
        
        let request = task.validate().responseJSON(queue: queue, options: .allowFragments) { (response) in
            let urlResponce = response.response
            if let error = response.error {
                completion?(urlResponce, nil, .error(error: error))
                return
            }
            
            switch response.result {
            case .success(let value):
                guard let json = value as? AnyDict else {
                    completion?(urlResponce, nil, .failedSerialization)
                    return
                }
                
                completion?(urlResponce, json, nil)
            case .failure(let error):
                completion?(urlResponce, nil, .error(error: error))
            }
        }
        
        return request
    }
    
    @discardableResult func performJSONs(task: DataRequest?, queue: DispatchQueue, completion: JSONsResponse?) -> Request? {
        guard let task = task else {
            let errorMessage = "Expect sessionManager should return DataTask"
            assertionFailure(errorMessage)
            completion?(nil, nil, .generic(description: errorMessage))
            
            return nil
        }
        
        let request = task.validate().responseJSON(queue: queue, options: .allowFragments) { (response) in
            let urlResponce = response.response
            if let error = response.error {
                completion?(urlResponce, nil, .error(error: error))
            }
            
            switch response.result {
            case .success(let value):
                if let json = value as? AnyDict, let errorMessage = json[NetworkError.errorKey] as? String {
                    completion?(urlResponce, nil, .generic(description: errorMessage))
                    return
                }
                
                guard let jsonArray = value as? [AnyDict] else {
                    completion?(urlResponce, nil, .failedSerialization)
                    return
                }
                
                completion?(urlResponce, jsonArray, nil)
            case .failure(let error):
                completion?(urlResponce, nil, .error(error: error))
            }
        }
        
        return request
    }
}
