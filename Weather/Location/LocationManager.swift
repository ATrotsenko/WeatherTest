//
//  LocationManager.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/21/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

typealias LocationResult = (CLLocationCoordinate2D?, LocationError?) -> Void

protocol LocationProvider: class {
    func getUserLocation(result: LocationResult?)
}

class LocationManagerImp: LocationProvider {
    func getUserLocation(result: LocationResult?) {
        LocationManager.shared.requireUserAuthorization()

        getLocationAccess { (success, error) in
            if !success {
                result?(nil, error)
                return
            }
            LocationManager.shared.onAuthorizationChange.removeAll()
            self.getCurrentUserLocation(result: result)
        }
    }
    
    private func getCurrentUserLocation(result: LocationResult?) {
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .any) { (dataResult) in
            switch dataResult {
            case .failure(let error):
                result?(nil, LocationError.error(error: error))
            case .success(let location):
                result?(location.coordinate, nil)
            }
        }
    }
    
    private func getLocationAccess(result: @escaping (Bool, LocationError?) -> Void) {
        LocationManager.shared.onAuthorizationChange.add { (newState) in
            switch newState {
            case .available:
                result(true, nil)
            default:
                result(false, LocationError.authorization(error: newState.description))
            }
        }
    }
}

class LocationManagerMock: LocationProvider {
    func getUserLocation(result: LocationResult?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            result?(CLLocationCoordinate2D(latitude: 47.82289, longitude: 35.19031), nil)
        }
    }
}
