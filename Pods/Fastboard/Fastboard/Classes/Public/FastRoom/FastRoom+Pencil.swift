//
//  FastRoom+Pencil.swift
//  Fastboard
//
//  Created by 许允是 on 2022/1/15.
//

import Foundation
import Whiteboard
import UIKit

extension FastRoom {
    func prepareForSystemPencilBehavior() {
        // Pencil stuff
        updateIfFollowSystemPencilBehavior(FastRoom.followSystemPencilBehavior)
        NotificationCenter.default.addObserver(self, selector: #selector(pencilFollowBehaviorDidChange), name: pencilBehaviorUpdateNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func onDidBecomeActiveNotification() {
        if #available(iOS 13.0, *) {
            if view.isPencilDrawOnly != UIPencilInteraction.prefersPencilOnlyDrawing {
                view.isPencilDrawOnly = UIPencilInteraction.prefersPencilOnlyDrawing
            }
        }
    }
    
    @objc func onWillResignActiveNotification() {
        view.pencilHandler?.recoverApplianceFromTempRemove()
    }
    
    @objc
    func pencilFollowBehaviorDidChange() {
        updateIfFollowSystemPencilBehavior(FastRoom.followSystemPencilBehavior)
    }
    
    fileprivate func updateIfFollowSystemPencilBehavior(_ follow: Bool) {
        if #available(iOS 12.1, *) {
            if #available(iOS 13.0, *) {
                view.isPencilDrawOnly = follow ? UIPencilInteraction.prefersPencilOnlyDrawing : false
            }
            if follow {
                if !view.interactions.contains(where: { $0 is UIPencilInteraction }) {
                    let pencil = UIPencilInteraction()
                    pencil.delegate = self
                    view.addInteraction(pencil)
                }
            } else {
                if let interaction = view.interactions.compactMap({ $0 as? UIPencilInteraction }).first {
                    view.removeInteraction(interaction)
                }
            }
        }
    }
}

extension FastRoom: UIPencilInteractionDelegate {
    @available(iOS 12.1, *)
    public func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        view.overlay?.respondToPencilTap?(UIPencilInteraction.preferredTapAction)
    }
}
