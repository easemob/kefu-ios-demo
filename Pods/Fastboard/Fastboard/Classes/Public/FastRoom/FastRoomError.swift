//
//  FastRoomError.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/28.
//

import Foundation

let errorDomain = "io.agora.fastboard"

@objc
public enum FastRoomErrorType: Int {
    case setupSDK = 0
    case joinRoom = 1000
    case disconnected = 2000
}

@objc
public class FastRoomError: NSError {
    let type: FastRoomErrorType
    
    init(type: FastRoomErrorType, error: Error) {
        self.type = type
        super.init(domain: errorDomain, code: type.rawValue, userInfo: (error as NSError).userInfo)
    }
    
    init(type: FastRoomErrorType, info: [String: Any]? = nil) {
        self.type = type
        super.init(domain: errorDomain, code: type.rawValue, userInfo: info)
    }
    
    public override var localizedDescription: String {
        switch type {
        case .setupSDK:
            return .localizedStringFrom(key: "setupSDKError")
        case .disconnected:
            return .localizedStringFrom(key: "disconnectedError")
        case .joinRoom:
            return .localizedStringFrom(key: "joinRoomError")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
