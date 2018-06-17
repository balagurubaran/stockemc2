//
//  UIView+Animation.swift
//  PennyPlus
//
//  Created by Kalingarayan, Balagurubaran on 11/28/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func heartBeatAnimation (toVlaue:Float = 1.1){
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = toVlaue
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 100
        animationGroup.animations = [pulse1]
        
        self.layer.add(animationGroup, forKey: "pulse")
    }
    
    func flip(view:UIView) {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: self, duration: 0.6, options: transitionOptions, animations: {
            self.isHidden = false
        })
        
        UIView.transition(with: view, duration: 0.6, options: transitionOptions, animations: {
            view.isHidden = true
        })
    }
    func dropShadow(scale: Bool = false) {
//        let layer: CALayer? = self.layer
//        layer?.cornerRadius = 5.0
//        layer?.masksToBounds = false
//        layer?.shadowOffset = CGSize.zero //CGSize(width: 0, height: 1)
//        layer?.shadowColor = UIColor.black.cgColor
//        layer?.shadowRadius = 5.0
//        layer?.shadowOpacity = 0.5
//        layer?.shadowPath = UIBezierPath(roundedRect: layer?.bounds ?? CGRect.zero, cornerRadius: layer?.cornerRadius ?? 0.0).cgPath
//        let bColor: CGColor? = self.backgroundColor?.cgColor
//        self.backgroundColor = nil
//        layer?.backgroundColor = bColor

        let layer           = self.layer
        layer.cornerRadius = 5.0
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius  = 2
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
