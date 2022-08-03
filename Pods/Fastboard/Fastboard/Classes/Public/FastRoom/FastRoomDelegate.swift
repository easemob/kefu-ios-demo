//
//  FastboardDelegate.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/29.
//

import Foundation
import Whiteboard

/// Represents the fastboard behavior
@objc
public protocol FastRoomDelegate: AnyObject {
    func fastboardDidJoinRoomSuccess(_ fastboard: FastRoom, room: WhiteRoom)
    
    func fastboardDidOccurError(_ fastboard: FastRoom, error: FastRoomError)
    
    func fastboardUserKickedOut(_ fastboard: FastRoom, reason: String)
    
    func fastboardPhaseDidUpdate(_ fastboard: FastRoom, phase: FastRoomPhase)
    
    @objc optional
    func fastboardDidSetupOverlay(_ fastboard: FastRoom, overlay: FastRoomOverlay?)
}
