//
//  UIColor+Convince.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/30.
//

import UIKit

extension UIColor {
    convenience init (hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 {
            self.init(r: 0, g: 0, b: 0, a: 1)
            return
        }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 {
            self.init(r: 0, g: 0, b: 0, a: 1)
            return
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt64 = 0x0
        var g: UInt64 = 0x0
        var b: UInt64 = 0x0
        
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        
        self.init(r: UInt32(r), g: UInt32(g), b: UInt32(b))
    }
    
}
