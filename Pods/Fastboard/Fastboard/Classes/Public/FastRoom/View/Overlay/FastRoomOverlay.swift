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
    
    func updateUIWithInitAppliance(_ appliance: WhiteApplianceNameKey?, shape: WhiteApplianceShapeTypeKey?)
    
    func updateStrokeColor(_ color: UIColor)
    
    func updateStrokeWidth(_ width: Float)
    
    func updatePageState(_ state: WhitePageState)
    
    func updateUndoEnable(_ enable: Bool)
    
    func updateRedoEnable(_ enable: Bool)
    
    func updateBoxState(_ state: WhiteWindowBoxState?)
    
    func updateRoomPhaseUpdate(_ phase: FastRoomPhase)
    
    @available(iOS 12.1, *)
    @objc
    optional func respondToPencilTap(_ tap: UIPencilPreferredAction)
}
