//
//  BaseView.swift
//  CustomComponent
//
//  Created by Kalingarayan, Balagurubaran on 10/18/17.
//  Copyright © 2017 Kalingarayan, Balagurubaran. All rights reserved.
//

import Foundation
import UIKit

class BaseView:UIView {
    
    var viewOne:ChildView = ChildView()
    var viewTwo:ChildView = ChildView()
    var viewThree:ChildView = ChildView()
    var viewFour:ChildView = ChildView()
    
    
    var viewArray = [ChildView]()
    
    var isAnimated = false
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initialSetUp()
        //self.makeRoundRectView(view: self)
    }
    
    
    
    func initialSetUp(){
        let frame = self.frame
        let viewOne = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        viewTwo = ChildView.init(frame: CGRect.init(x: 0, y: 0 , width: frame.size.width, height: frame.size.height))
        viewThree = ChildView.init(frame: CGRect.init(x: 0, y:viewTwo.frame.size.height, width: frame.size.width, height: frame.size.height))
        viewFour = ChildView.init(frame: CGRect.init(x: 0, y:viewTwo.frame.size.height + viewThree.frame.origin.y, width: frame.size.width, height: frame.size.height))
        
        viewTwo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewThree.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewFour.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewOne.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewThree.backgroundColor = UIColor.yellow
        viewTwo.backgroundColor = UIColor.green
        viewFour.backgroundColor = UIColor.red
        
        viewArray.append(viewTwo)
        viewArray.append(viewThree)
        viewArray.append(viewFour)
        
        for animateView in viewArray {
            self.addSubview(animateView)
            //animateView.backgroundColor = UIColor.black
            //animateView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
            animateView.isHidden = true
           // self.addSubview(animateView)
            animateView.layer.transform =  viewTwo.transform3d()
            self.makeRoundRectView(view: animateView)
        }
        
        self.addSubview(viewOne)
        //self.makeRoundRectView(view: viewOne)
        
    }
    
    fileprivate func makeRoundRectView(view:UIView){
        view.layer.borderWidth = 2;
        view.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.initialSetUp()
        //fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var i = 0.0;
        let isReverse = isAnimated ? viewArray.reversed() : viewArray
        
         for animateView in isReverse {
            animateView.foldingAnimation(duration: 0.1, delay: i, hidden: false)
            i  = i + 0.1
        }
        isAnimated = !isAnimated

    }
}

class ChildView:UIView {
    var isAnimated = false
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func rotatedX(_ angle : CGFloat) {
        var allTransofrom    = CATransform3DIdentity;
        let rotateTransform  = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransofrom        = CATransform3DConcat(allTransofrom, rotateTransform)
        allTransofrom        = CATransform3DConcat(allTransofrom, transform3d())
        self.layer.transform = allTransofrom
    }
    
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000;
        return transform
    }
    
     // MARK: animations
    func foldingAnimation(duration: TimeInterval, delay:TimeInterval, hidden:Bool) {
        
        print(self.isAnimated)
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction      = CAMediaTimingFunction(name: !self.isAnimated ? FoldAnimation.timing:UnFoldAnimation.timing)

        rotateAnimation.fromValue = !self.isAnimated ? FoldAnimation.from:UnFoldAnimation.from
        rotateAnimation.toValue   = !self.isAnimated ? FoldAnimation.to:UnFoldAnimation.to
        
        //self.backgroundColor = !self.isAnimated ? FoldAnimation.Color:UnFoldAnimation.Color

        rotateAnimation.duration            = duration
        rotateAnimation.delegate            = self;
        rotateAnimation.fillMode            = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false;
        rotateAnimation.beginTime           = CACurrentMediaTime() + delay
        
        self.layer.add(rotateAnimation, forKey: "rotation.x")
    }
}

extension ChildView:CAAnimationDelegate{

    struct animationViewPosition {
        static var Y:CGFloat = CGFloat()
    }

    struct FoldAnimation {
        static let timing                = kCAMediaTimingFunctionEaseIn
        static let from: CGFloat         = 0.0
        static let to: CGFloat           = -CGFloat.pi / 2
        static let Color                 = UIColor.green
    }
    
     struct UnFoldAnimation {
        static let timing                = kCAMediaTimingFunctionEaseIn
        static let from: CGFloat         = 0.0
        static let to: CGFloat           = CGFloat.pi / 2
        static let Color                 = UIColor.red
    }

    
    public func animationDidStart(_ anim: CAAnimation) {
        
        self.isHidden = false
        self.layer.shouldRasterize = true
        self.alpha = 1
         if (self.isAnimated){
            print("animationDidStart")
            self.frame.origin = CGPoint.init(x: 0, y:self.frame.origin.y - self.frame.size.height/2)
            self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        }
        else {
            isHidden = false
            self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
            self.frame.origin = CGPoint.init(x: 0, y:self.frame.origin.y + self.frame.size.height/2)
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.removeAllAnimations()
        self.layer.shouldRasterize = false
        rotatedX(CGFloat(0))
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
    
        if(animationViewPosition.Y == 0){
            animationViewPosition.Y = self.frame.origin.y + self.frame.size.height/2
        }else {
            animationViewPosition.Y = isAnimated ? animationViewPosition.Y - self.frame.size.height: self.frame.size.height + animationViewPosition.Y
        }
        
        if (self.isAnimated){
            isHidden = true
        }
        
        self.isAnimated =  !self.isAnimated
        
        self.frame.origin = CGPoint.init(x: 0, y:animationViewPosition.Y)
        // self.foldingAnimation(timing, from: from, to: to, duration: 2, delay: delay, hidden: false)
    }
    
    
}
