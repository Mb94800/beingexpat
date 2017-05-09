//
//  Extensions.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 30/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation


import UIKit

extension UIView {
    
    func makeCircle() {
        // Assumes image is a square
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
    }
    
    func makeCircleWithBorderColor(color: UIColor, width: CGFloat) {
        self.makeCircle()
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}
