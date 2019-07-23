//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static var size = CGSize(width: 80, height: 145)
    
    @IBOutlet weak var timeHourLabel: UILabel!
    @IBOutlet weak var weatherIcoImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func set(weather: WeatherViewModel?) {
        timeHourLabel.text = weather?.hourTime
        tempLabel.text = weather?.temp
        weatherIcoImageView.image = UIImage(named: weather?.weatherIconName ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
