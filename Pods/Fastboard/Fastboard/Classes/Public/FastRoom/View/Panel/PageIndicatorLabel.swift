//
//  PageIndicatorLabel.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/19.
//

import UIKit

class PageIndicatorLabel: UILabel {
    @objc dynamic var configurableTextColor: UIColor {
        get {
            return textColor
        }
        set {
            textColor = newValue
        }
    }
}
