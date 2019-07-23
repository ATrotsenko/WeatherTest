//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 75.0
    
    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!

    
    func set(weather: WeatherViewModel?) {
        minMaxTempLabel.text = weather?.tempMinMax
        dayLabel.text = weather?.dayName.uppercased()
        weatherIconImageView.image = UIImage(named: weather?.weatherIconName ?? "")
        setSelected(false)
    }
    
    
    func setSelected(_ selected: Bool) {
        shadowView.applyShadow(apply: selected, color: #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1) , offset: .zero, opacity: 0.3, radius: 6)
        minMaxTempLabel.textColor = selected ? #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1) : .black
        dayLabel.textColor = selected ? #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1) : .black
        weatherIconImageView.changeColor(selected ? #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1) : .black)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSelected(selected)
    }
}
