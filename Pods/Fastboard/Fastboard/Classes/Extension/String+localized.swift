//
//  String+localized.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/2/18.
//

import Foundation

extension String {
    static func localizedStringFrom(key: String) -> Self {
        NSLocalizedString(key, bundle: .localizedBundle, comment: "")
    }
}
