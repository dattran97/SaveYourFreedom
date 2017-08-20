//
//  Animator.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/17/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class Animator{
    
    @discardableResult
    static func move(view:UIView, to newLocation: CGPoint, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, curve: .linear, animations: {
            view.center = newLocation
        })
    }
    
    @discardableResult
    static func moveWithDamping(view:UIView, to newLocation: CGPoint, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, dampingRatio: 0.45) {
            view.center = newLocation
        }
    }
    
    @discardableResult
    static func rotate(view:UIView, to angle: Double, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
    }
}
