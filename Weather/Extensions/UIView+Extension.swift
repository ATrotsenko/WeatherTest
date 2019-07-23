//
//  UIView+Extension.swift
//  Weather
//
//  Created by Alexey Trotsenko on 7/22/19.
//  Copyright © 2019 Alexey Trotsenko. All rights reserved.
//

import UIKit

extension UIView {
    
    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    func applyShadow(
        apply: Bool,
        color: UIColor = UIColor.black,
        offset: CGSize = CGSize(width: 0.0, height: 2.0),
        opacity: Float = 0.2, radius: Float = 1.0,
        shadowRect: CGRect? = nil) {
        self.layer.shadowColor = apply ? color.cgColor : UIColor.white.withAlphaComponent(0.0).cgColor
        self.layer.shadowOffset = apply ? offset : CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = apply ? opacity : 0.0
        self.layer.shadowRadius = apply ? CGFloat(radius) : 0.0
        self.layer.masksToBounds = false
        if let shadowRect = shadowRect {
            self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }
}
