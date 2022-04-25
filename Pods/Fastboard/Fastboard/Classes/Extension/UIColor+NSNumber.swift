//
//  UIColor+NSNumber.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/29.
//

import UIKit

extension UIColor {
    convenience init(r: UInt32 ,g: UInt32 , b: UInt32 , a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    convenience init (numberArray: [NSNumber]){
        let arrayCount = numberArray.count
        guard arrayCount >= 3 else {
            self.init(r: 0, g: 0, b: 0)
            return
        }
        let r = UInt32(truncating: numberArray[0])
        let g = UInt32(truncating: numberArray[1])
        let b = UInt32(truncating: numberArray[2])
        self.init(r: r, g: g, b: b, a: arrayCount >= 4 ? CGFloat(truncating: numberArray[3]) : 1)
    }
    
    func getNumbersArray() -> [NSNumber] {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return [NSNumber(value: Int(r * 255)),
                NSNumber(value: Int(g * 255)),
                NSNumber(value: Int(b * 255))]
    }
}
