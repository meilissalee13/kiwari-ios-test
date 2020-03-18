//
//  UIView+Extensions.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
      get {
        return layer.cornerRadius
      }
      set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
      }
    }
    
    func makeRoundedOutlineBorder(borderWidth: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}

