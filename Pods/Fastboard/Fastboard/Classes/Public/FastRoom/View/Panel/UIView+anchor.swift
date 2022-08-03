//
//  UIView+widthAnchor.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/19.
//

import Foundation

private var _fast_w: Void?
private var _fast_h: Void?
extension UIView {
    var _fast_width_anchor: CGFloat? {
        get {
            (objc_getAssociatedObject(self, &_fast_w) as? NSLayoutConstraint)?.constant
        }
        set {
            if let new = newValue {
                if let con = objc_getAssociatedObject(self, &_fast_w) as? NSLayoutConstraint {
                    con.constant = new
                    con.isActive = true
                } else {
                    let con = widthAnchor.constraint(equalToConstant: new)
                    con.isActive = true
                    objc_setAssociatedObject(self, &_fast_w, con, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                if let con = objc_getAssociatedObject(self, &_fast_w) as? NSLayoutConstraint {
                    con.isActive = false
                }
                objc_setAssociatedObject(self, &_fast_w, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var _fast_height_anchor: CGFloat? {
        get {
            (objc_getAssociatedObject(self, &_fast_h) as? NSLayoutConstraint)?.constant
        }
        set {
            if let new = newValue {
                if let con = objc_getAssociatedObject(self, &_fast_h) as? NSLayoutConstraint {
                    con.constant = new
                    con.isActive = true
                } else {
                    let con = heightAnchor.constraint(equalToConstant: new)
                    con.isActive = true
                    objc_setAssociatedObject(self, &_fast_h, con, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                if let con = objc_getAssociatedObject(self, &_fast_h) as? NSLayoutConstraint {
                    con.isActive = false
                }
                objc_setAssociatedObject(self, &_fast_h, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
