//
//  GeneralWeatherView.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

class GeneralWeatherView: UIView {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weaherImageView: UIImageView!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func update(weather: WeatherViewModel?) {
        cityNameLabel.text = weather?.cityName
        dateLabel.text = weather?.date
        minMaxTempLabel.text = weather?.tempMinMax
        humidityLabel.text = weather?.humidity
        windSpeedLabel.text = weather?.windSpeed
        weaherImageView.image = UIImage(named: weather?.weatherIconName ?? "")
        windDirectionImageView.image = UIImage(named: weather?.windDirectionIconName ?? "")
    }

    private func commonInit() {
        let view = loadNib()
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
