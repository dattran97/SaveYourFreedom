//
//  Player.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/20/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class Player{
    let element = UIImageView()
    var moveAnimator:UIViewPropertyAnimator?
    var rotateAnimator:UIViewPropertyAnimator?
    
    init(){
        element.layer.zPosition = CGFloat.greatestFiniteMagnitude
        element.frame.size = CGSize(width: PlayerConstants.size, height: PlayerConstants.size)
        element.center.x = ScreenSize.width/2
        element.center.y = ScreenSize.height/2
        element.layer.cornerRadius = element.frame.size.width/2
        element.image = UIImage(named: "player")
        element.contentMode = .scaleAspectFill
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.clear.cgColor
    }
    
    func move(to location:CGPoint, duration: Double){
        moveAnimator = Animator.moveWithDamping(view: self.element, to: location, duration: duration)
        moveAnimator?.startAnimation()
    }
    
    func rotate(to point: CGPoint){
        let angle = self.element.center.getAngle(with: point) - EnemyConstants.defaultAngle
        rotateAnimator = Animator.rotate(view: self.element, to:angle, duration: 0.4)
        rotateAnimator?.startAnimation()
    }
}
