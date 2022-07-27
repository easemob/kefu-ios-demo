//
//  FastRoomView+Pencil.swift
//  Fastboard
//
//  Created by 许允是 on 2022/1/15.
//

import Foundation
import Whiteboard

extension FastRoomView {
    /// Call this after webView setup
    func prepareForPencil() {
        if let webTouchGesture = whiteboardView.scrollView.subviews
            .first(where: {
                $0.classForCoder.description() == "WKContentView"
            })?.gestureRecognizers?
            .first(where: {
                $0.classForCoder.description() == "UIWebTouchEventsGestureRecognizer"
            }) {
            
            pencilHandler = FastboardPencilDrawHandler(room: whiteboardView.room, drawOnlyPencil: isPencilDrawOnly)
            pencilHandler?.originalDelegate = webTouchGesture.delegate
            webTouchGesture.delegate = pencilHandler
        }
    }
}
