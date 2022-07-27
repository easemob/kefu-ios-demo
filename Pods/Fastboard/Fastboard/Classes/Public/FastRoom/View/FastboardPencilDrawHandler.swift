//
//  FastboardPencilHandler.swift
//  Fastboard
//
//  Created by 许允是 on 2022/1/16.
//

import Foundation
import Whiteboard

extension WhiteApplianceNameKey {
    var drawable: Bool {
        switch self {
        case .AppliancePencil:
            return true
        default:
            return false
        }
    }
}

/// Handler UIWebGestureRecognizer on the WKWebView, and determine when to pass the touch to WKWebView
/// So it controls whether user can drawing by hand or pencil
/// Basically, it changed the appliance to clicker when 'drawOnlyPencil' is true and recover it when the next time pencil is touching
/// If the room appliance changed external, it will invalidate the removed status
///
/// What else:
/// It won't effect on the UIPencilPreferredAction for it only relies on the RegularOverlay
/// Changing event won't be transmitted to RegularOverlay
class FastboardPencilDrawHandler: NSObject {
    var drawOnlyPencil: Bool {
        didSet {
            if !drawOnlyPencil  {
                recoverApplianceFromTempRemove()
            }
        }
    }
    
    init(room: WhiteRoom?, drawOnlyPencil: Bool) {
        self.drawOnlyPencil = drawOnlyPencil
        super.init()
        self.room = room
    }
    weak var originalDelegate: UIGestureRecognizerDelegate?
    weak var room: WhiteRoom?
    fileprivate var isPencilTouch = false
    fileprivate var removedAppliance: WhiteApplianceNameKey?
    
    /// Temporarily removed appliance will trigger an async roomApplianceUpdate callback
    /// To distinguish from manual changing and temporally removed, the first callback will be dropped
    fileprivate var shouldDropFirstUpdate = false

    /// The function will be called after room appliance was manual changed
    /// To notify that appliance status is changed
    /// If appliance changed outside, then the removed status should be invalidate
    func roomApplianceDidUpdate() {
        guard let removedAppliance = removedAppliance
        else { return }
        if shouldDropFirstUpdate {
            shouldDropFirstUpdate = false
            return
        }
        if room?.memberState.currentApplianceName != removedAppliance {
            self.removedAppliance = nil
        }
    }
    
    /// Remove the appliance temporally or touch direct on screen
    /// It will recover after the pencil touch
    func removeApplianceIfNeed() {
        guard removedAppliance == nil else { return }
        guard let current = room?.state.memberState?.currentApplianceName else { return }
        if current.drawable {
            shouldDropFirstUpdate = true
            removedAppliance = current
            let state = WhiteMemberState()
            state.currentApplianceName = .ApplianceClicker
            room?.setMemberState(state)
        }
    }
    
    /// Try recover room appliance from events:
    /// - 1. Pencil touch
    /// - 2. Room will disconnect
    /// - 3. App will terminate
    func recoverApplianceFromTempRemove() {
        if let removedAppliance = removedAppliance {
            let state = WhiteMemberState()
            state.currentApplianceName = removedAppliance
            room?.setMemberState(state)
            self.removedAppliance = nil
        }
    }
}

extension FastboardPencilDrawHandler: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !drawOnlyPencil {
            return originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) ?? true
        }
        isPencilTouch = touch.type == .pencil
        if !isPencilTouch {
            removeApplianceIfNeed()
        } else {
            recoverApplianceFromTempRemove()
        }
        return originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) ?? true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        originalDelegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
    }
}
