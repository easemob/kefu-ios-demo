//
//  WhiteBoardView+Theme.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/6.
//

import UIKit
import Whiteboard

extension WhiteBoardView {
    @objc
    dynamic var themeBgColor: UIColor? {
        get { nil }
        set {
            if #available(iOS 13.0, *) {
                backgroundColor = newValue?.resolvedColor(with: traitCollection)
                traitCollectionUpdateHandler = { [weak self] t in
                    if let t = self?.traitCollection {
                        self?.backgroundColor = newValue?.resolvedColor(with: t)
                    }
                }
            } else {
                backgroundColor = newValue
            }
        }
    }
}
