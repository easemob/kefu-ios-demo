//
//  UIView+Theme.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/6.
//

import UIKit

extension UIView {
    @objc
    dynamic var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
            self.traitCollectionUpdateHandler = { [weak self] _ in
                self?.layer.borderColor = newValue?.cgColor
            }
        }
    }
}
