//
//  Bundle+localizedString.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/2/18.
//

import Foundation

extension Bundle {
    static var localizedBundle: Bundle {
        let path = Bundle(for: Fastboard.self).path(forResource: "LocalizedStrings", ofType: "bundle")
        return Bundle(path: path!)!
    }
}
