//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/23/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

extension UIImageView {

    func changeColor(_ color: UIColor) {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}
