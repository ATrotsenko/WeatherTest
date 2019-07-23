//
//  AppDelegate.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/18/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let weatherViewModel = MainWeatherViewModel(weatherApi: WeatherAPIImpl(networkLayer: BaseNetworkLayerImpl()),
                                                    locationManager: LocationManagerImp())
        let startController = MainWeatherViewController(viewModel: weatherViewModel)
        UIViewController.setRoot(startController)
        return true
    }
}

