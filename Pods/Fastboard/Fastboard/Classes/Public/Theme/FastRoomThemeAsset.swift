//
//  Theme.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/28.
//

import UIKit

/// Represents whiteboard theme style
open class FastRoomWhiteboardAssets: NSObject {
    @objc
    public init(whiteboardBackgroundColor: UIColor, containerColor: UIColor) {
        self.whiteboardBackgroundColor = whiteboardBackgroundColor
        self.containerColor = containerColor
    }
    
    @objc
    open var whiteboardBackgroundColor: UIColor
    
    @objc
    open var containerColor: UIColor
}

/// Represents panelItem theme style
open class FastRoomPanelItemAssets: NSObject {
    @objc
    public init(normalIconColor: UIColor,
                selectedIconColor: UIColor,
                selectedIconBgColor: UIColor,
                highlightColor: UIColor,
                highlightBgColor: UIColor,
                disableColor: UIColor,
                subOpsIndicatorColor: UIColor,
                pageTextLabelColor: UIColor) {
        self.normalIconColor = normalIconColor
        self.selectedIconColor = selectedIconColor
        self.selectedIconBgColor = selectedIconBgColor
        self.highlightColor = highlightColor
        self.highlightBgColor = highlightBgColor
        self.disableColor = disableColor
        self.subOpsIndicatorColor = subOpsIndicatorColor
        self.pageTextLabelColor = pageTextLabelColor
    }
    
    @objc
    open var normalIconColor: UIColor
    
    @objc
    open var selectedIconColor: UIColor
    
    @objc
    open var selectedIconBgColor: UIColor
    
    @objc
    open var highlightColor: UIColor
    
    @objc
    open var highlightBgColor: UIColor
    
    @objc
    open var disableColor: UIColor
    
    @objc
    open var subOpsIndicatorColor: UIColor
    
    @objc
    open var pageTextLabelColor: UIColor
}

/// Represents controlBar theme style
open class FastRoomControlBarAssets: NSObject {
    @objc
    public init(backgroundColor: UIColor, borderColor: UIColor, effectStyle: UIBlurEffect? = nil) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.effectStyle = effectStyle
    }
    
    @objc
    var backgroundColor: UIColor
    
    @objc
    var borderColor: UIColor
    
    @objc
    var effectStyle: UIBlurEffect?
}

/// Represents fastboard theme style
open class FastRoomThemeAsset: NSObject {
    @objc
    public init(whiteboardAssets: FastRoomWhiteboardAssets,
                controlBarAssets: FastRoomControlBarAssets,
                panelItemAssets: FastRoomPanelItemAssets) {
        self.whiteboardAssets = whiteboardAssets
        self.controlBarAssets = controlBarAssets
        self.panelItemAssets = panelItemAssets
    }
    
    @objc
    open var whiteboardAssets: FastRoomWhiteboardAssets
    
    @objc
    open var controlBarAssets: FastRoomControlBarAssets
    
    @objc
    open var panelItemAssets: FastRoomPanelItemAssets
}
