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
    
    func setBorder(sizeBorder: CGFloat, color: CGColor? = nil){
        self.layer.borderWidth = sizeBorder
        self.layer.borderColor = color
    }
    
    
    func makeSemiCircle(){
        let arcCenter = CGPoint(x:self.bounds.size.width/2,y:0)
        let circlePath = UIBezierPath.init(arcCenter: arcCenter, radius: CGFloat(self.bounds.size.height),startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath 
        circleShape.lineWidth = 200
        self.layer.mask = circleShape
    }
    
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
