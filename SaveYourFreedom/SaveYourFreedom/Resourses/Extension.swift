//
//  Extension.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/18/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
}

extension CGPoint{
    func getAngle(with point:CGPoint) -> Double{
        if self.x == point.x { return 0 }
        if self.y == point.y { return Double.pi/2 }
        let angle = Double(atan((point.x - self.x)/(point.y - self.y)))

        if self.x > point.x && self.y > point.y{
            return -angle
        }else if self.x < point.x && self.y > point.y{
            return 2*Double.pi - angle
        }
        return Double.pi - angle
    }
    
    func getDistance(to point:CGPoint) -> Double{
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(Double(dx * dx + dy * dy))
    }
}

extension UIView{
    var presentationFrame:CGRect? {
        get{
            return self.layer.presentation()?.frame
        }
    }
    
    var presentationCenter:CGPoint? {
        get{
            guard let frame = self.presentationFrame else { return nil }
            return CGPoint(x: frame.origin.x - frame.size.width/2, y: frame.origin.y - frame.size.height/2)
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position : CGPoint = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }

}

extension Array {
    func getRandomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UserDefaults {
    static var highscore:Int {
        set(input){
            self.standard.setValue(input, forKey: "highscore")
        }
        get{
            return self.standard.value(forKey: "highscore") as? Int ?? 0
        }
    }
}
