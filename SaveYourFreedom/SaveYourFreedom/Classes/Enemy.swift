//
//  Enemy.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/20/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class Enemy{
    let element = UIImageView()
    var moveAnimator:UIViewPropertyAnimator?
    var rotateAnimator:UIViewPropertyAnimator?

    
    init(){
        element.layer.backgroundColor = UIColor.white.cgColor
        element.layer.borderWidth = 1
        element.animationImages = [UIImage(named: "enemy_blue_1")!, UIImage(named: "enemy_blue_2")!, UIImage(named: "enemy_blue_3")!, UIImage(named: "enemy_blue_2")!]
        element.animationDuration = 0.6
        element.startAnimating()
        element.frame.size = CGSize(width: EnemyConstants.size, height: EnemyConstants.size)
        element.contentMode = .scaleAspectFill
        switch EnemyConstants.directions.getRandomItem()!{
        case .top:
            element.frame.origin = CGPoint(x: CGFloat(arc4random_uniform(UInt32(ScreenSize.width))), y: -EnemyConstants.size)
        case .bottom:
            element.frame.origin = CGPoint(x: CGFloat(arc4random_uniform(UInt32(ScreenSize.width))), y: ScreenSize.height + EnemyConstants.size)
        case .left:
            element.frame.origin = CGPoint(x: -EnemyConstants.size, y: CGFloat(arc4random_uniform(UInt32(ScreenSize.height))))
        case .right:
            element.frame.origin = CGPoint(x: ScreenSize.width + EnemyConstants.size, y: CGFloat(arc4random_uniform(UInt32(ScreenSize.height))))
        }
    }
    
    func move(to location: CGPoint){
        moveAnimator = Animator.move(view: self.element, to: location, duration: self.getMoveDuration(to: location))
        moveAnimator?.startAnimation()
    }
    
    func rotate(to point: CGPoint, duration: Double? = nil){
        guard var angle = self.element.presentationCenter?.getAngle(with: point) else {
            return
        }
        angle = angle - EnemyConstants.defaultAngle
        rotateAnimator = Animator.rotate(view: self.element, to: angle, duration: duration ?? getRotateDuration(angle))
        rotateAnimator?.startAnimation()
    }
    
    func getMoveDuration(to location: CGPoint) -> TimeInterval {
        return TimeInterval(self.element.center.getDistance(to: location)/EnemyConstants.moveSpeed)
    }
    
    func getRotateDuration(_ angle: Double) -> TimeInterval {
        return angle/Double.pi * EnemyConstants.rotationSpeed
    }
}
