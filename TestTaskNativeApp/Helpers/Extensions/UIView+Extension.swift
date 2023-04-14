//
//  UIView+Extension.swift
//  TestTaskNativeApp
//
//  Created by Александр Янчик on 14.04.23.
//

import UIKit


extension UIView {
    func applyGradient(colors: [CGColor]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer ?? CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.shouldRasterize = true
        
        switch direction {
            case .topToBottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
            case .bottomToTop:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                
            case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
            case .rightToLeft:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        guard gradientLayer.superlayer != self else {
            return
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

enum Direction: Int {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
}
