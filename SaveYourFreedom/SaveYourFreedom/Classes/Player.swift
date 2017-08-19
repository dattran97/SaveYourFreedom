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
    
    init(){
        element.image = UIImage(named: "player")
        element.frame.size = CGSize(width: PlayerConstants.size, height: PlayerConstants.size)
        element.center.x = ScreenSize.width/2
        element.center.y = ScreenSize.height/2
        element.layer.cornerRadius = element.frame.size.width/2
    }
    
    func move(to location:CGPoint, duration: Double){
        Animator.move(view: self.element, to: location, duration: duration).startAnimation()
    }
}
