//
//  Fastboard.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/28.
//

import UIKit
import Whiteboard

let versionNumber = "1.0.8"

public class Fastboard: NSObject {
    /// Change this to update the whiteRoom ratio and whiteboardView ratio
    @objc
    public static var globalFastboardRatio: CGFloat = 16.0 / 9.0
    
    /// Create a Fastboard with FastConfiguration
    /// - Parameter configuration: Configuration for fastboard
    @objc
    public class func createFastRoom(withFastRoomConfig config: FastRoomConfiguration) -> FastRoom {
        return FastRoom(configuration: config)
    }
}
