//
//  Extension.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/18/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

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
