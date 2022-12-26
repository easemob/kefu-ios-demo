//
//  FastRoomOverlay.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/11.
//

import Foundation
import Whiteboard

@objc
public enum OperationBarDirection: Int {
    case left = 0
    case right
}

/// Represents the control layer for fastboard
@objc
public protocol FastRoomOverlay: FastPanelControl {
    func setupWith(room: WhiteRoom, fastboardView: FastRoomView, direction: OperationBarDirection)
    
    func invalidAllLayout()
    
    func updateControlBarLayout(direction: OperationBarDirection)
    
    func initUIWith(appliance: WhiteApplianceNameKey?, shape: WhiteApplianceShapeTypeKey?)
    
    func update(strokeColor: UIColor)
    
    func update(strokeWidth: Float)
    
    func update(pageState: WhitePageState)
    
    func update(undoEnable: Bool)
    
    func update(redoEnable: Bool)
    
    func update(boxState: WhiteWindowBoxState?)
    
    func update(roomPhase: FastRoomPhase)
    
    @available(iOS 12.1, *)
    @objc
    optional func respondTo(pencilTap: UIPencilPreferredAction)
}
