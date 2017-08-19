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
    
    init(){
        element.animationImages = [UIImage(named: "enemy_blue_1")!, UIImage(named: "enemy_blue_2")!, UIImage(named: "enemy_blue_3")!, UIImage(named: "enemy_blue_2")!]
        element.animationDuration = 0.33
        element.startAnimating()
        element.frame.size = CGSize(width: EnemyConstants.size, height: EnemyConstants.size)
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
        Animator.move(view: self.element, to: location, duration: self.getDuration(location)).startAnimation()
    }
    
    func getDuration(_ playerLocation: CGPoint) -> TimeInterval {
        let dx = playerLocation.x - self.element.frame.origin.x
        let dy = playerLocation.y - self.element.frame.origin.y
        return TimeInterval(sqrt(dx * dx + dy * dy) / EnemyConstants.speed)
    }
}
