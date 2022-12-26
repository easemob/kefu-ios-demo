//
//  FastConfiguration.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/12.
//

import Foundation
import Whiteboard

/// Contains the parameters for creating the Fastboard
public class FastRoomConfiguration: NSObject {
    /// Update whiteSDK configuration for detail here
    @objc
    public let whiteSdkConfiguration: WhiteSdkConfiguration
    
    /// Update whiteRoom configuration for detail here
    @objc
    public let whiteRoomConfig: WhiteRoomConfig
    
    /// Assign a custom overlay to create your own overlay style
    @objc
    public var customOverlay: FastRoomOverlay? = nil
 
    /// Create FastConfiguration
    /// - Parameters:
    ///   - appIdentifier: The only identifier for Fastboard. See [Fetch App Identifier](https://docs.agora.io/cn/whiteboard/enable_whiteboard?platform=iOS#%E8%8E%B7%E5%8F%96-app-identifier).
    ///   - roomUUID: Identifier for the room.
    ///   - roomToken: For room authentication.
    ///   - region: Data center.
    ///   - userUID: User identifier. Can be any string.
    @objc
    public init(appIdentifier: String,
                roomUUID: String,
                roomToken: String,
                region: Region,
                userUID: String) {
        let wsc = WhiteSdkConfiguration(app: appIdentifier)
        wsc.setValue(["fastboard/\(versionNumber)"], forKey: "netlessUA")
        wsc.renderEngine = .canvas
        wsc.userCursor = false
        wsc.useMultiViews = true
        wsc.region = region.toWhiteRegion()
        if #available(iOS 14.0, *) {
            if ProcessInfo.processInfo.isiOSAppOnMac {
                wsc.deviceType = .desktop
            }
        }
        wsc.log = true
        wsc.loggerOptions["printLevelMask"] = WhiteSDKLoggerOptionLevelKey.error.rawValue
        whiteSdkConfiguration = wsc
        let wrc = WhiteRoomConfig(uuid: roomUUID, roomToken: roomToken, uid: userUID)
        wrc.disableNewPencil = false
        let windowParas = WhiteWindowParams()
        windowParas.chessboard = false
        windowParas.containerSizeRatio = NSNumber(value: 1 / Fastboard.globalFastboardRatio)
        wrc.windowParams = windowParas
        wrc.disableEraseImage = true
        whiteRoomConfig = wrc
        super.init()
    }
    
    @available(*, deprecated, message: "use the designed init instead")
    public override init() {
        #if DEBUG
        fatalError("use the designed init instead")
        #else
        self.whiteRoomConfig = WhiteRoomConfig()
        self.whiteSdkConfiguration = WhiteSdkConfiguration.init(app: "")
        super.init()
        #endif
    }
}
