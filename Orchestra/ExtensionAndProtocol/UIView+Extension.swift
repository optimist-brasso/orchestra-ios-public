//
//  UIView+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

extension UIView {
    
    var curve: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    func set(borderWidth width: CGFloat = 1, of color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func rounded() {
        curve = frame.width / 2
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    func addDashedCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                      radius: min(frame.size.height, frame.size.width) / 2,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true).cgPath
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath
        circleLayer.lineWidth = 8.0
        circleLayer.strokeColor =  UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineJoin = .round
        circleLayer.lineDashPattern = [10, 8]
        layer.addSublayer(circleLayer)
    }
    
    var leftCurve: CGFloat {
        get { self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            self.layer.masksToBounds = true
        }
    }
    
    var topCurve: CGFloat {
        get { self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = CACornerMask(rawValue: 3)
            self.layer.masksToBounds = true
        }
    }
    
}
