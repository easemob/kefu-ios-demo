//
//  Region.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/12.
//

import Foundation
import Whiteboard

/// Data Center
@objc (FastRegion)
public enum Region: Int {
    /// China
    case CN = 0
    /// USA
    case US
    /// Singapore
    case SG
    /// India
    case IN
    /// England
    case GB
    
    func toWhiteRegion() -> WhiteRegionKey {
        switch self {
        case .CN:
            return .CN
        case .US:
            return .US
        case .SG:
            return .SG
        case .IN:
            return .IN
        case .GB:
            return .GB
        }
    }
}
