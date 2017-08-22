//
//  Animator.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/17/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class Animator{
    
    static func move(view:UIView, to newLocation: CGPoint, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, dampingRatio: 0.5) {
            view.center = newLocation
        }
    }
    
    static func moveWithDamping(view:UIView, to newLocation: CGPoint, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, dampingRatio: 0.5) {
            view.center = newLocation
        }
    }
    
    static func rotate(view:UIView, to angle: Double, duration: Double) -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(duration: duration, dampingRatio: 0.2, animations: {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
    }
    
//    static func transitionToEndScreen(playerView: UIImageView, duration: Double) -> UIViewPropertyAnimator{
//        
//    }
    
    static func rotateWithRepeat(view: UIView, duration: Double, changingSpeed:Bool = false) -> CABasicAnimation{
        let zKeyPath = "layer.presentationLayer.transform.rotation.z"
        let initialAngle = (view.value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = (changingSpeed) ? initialAngle : 0
        rotate.toValue = Float.pi * 2 + ((changingSpeed) ? initialAngle : 0)
        rotate.repeatCount = Float.greatestFiniteMagnitude
        rotate.duration = duration
        return rotate
    }
    
    static func scaleUp(view:UIView, duration: Double) -> CABasicAnimation{
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 20
        scale.duration = duration
        return scale
    }
    
    static func crossfade(to toImage:UIImage, view:UIImageView, duration: Double){
        let animation = CATransition()
        animation.duration = duration
        animation.type = kCATransitionFade
        view.layer.add(animation, forKey: "crossfade")
        view.image = toImage
    }
    
    //MARK: - Support functions
    static func changeRotationDuration(view:UIView, toDuration:Double, animationKey:String){
        guard let _ = view.layer.animation(forKey: animationKey) else { return }
        view.layer.removeAnimation(forKey: animationKey)
        view.layer.add(Animator.rotateWithRepeat(view: view, duration: toDuration, changingSpeed: true), forKey: animationKey)
    }
}
