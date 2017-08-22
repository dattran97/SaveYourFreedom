//
//  Constants.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/20/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

struct PlayerConstants{
    static let size:CGFloat = 36
    static let speed:CGFloat = 1 //seconds per 10 point
}

struct EnemyConstants{
    static let defaultHeadRatio:Double = 0.64
    static let defaultAngle:Double = .pi/4
    static let size:CGFloat = 24
    static let moveSpeed:Double = 1 //px per 1 second
    static let rotationSpeed:Double = 0.1 //seconds per pi
    static let directions:[Direction] = [.top, .left, .right, .bottom]
    static let colors = ["blue", "green"]
}

struct ScreenSize{
    static let width:CGFloat            = UIScreen.main.bounds.size.width
    static let height:CGFloat           = UIScreen.main.bounds.size.height
}

enum GameState{
    case pending
    case playing
    case end
    case animating
}

enum Direction{
    case top
    case left
    case right
    case bottom
}
