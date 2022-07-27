//
//  FastRoomThemeManager.swift
//  dsBridge
//
//  Created by xuyunshi on 2021/12/28.
//

import UIKit
import Whiteboard

/// Manage the fastboard theme style
@objc
public class FastRoomThemeManager: NSObject {
    @objc
    public static let shared = FastRoomThemeManager()
    
    private override init() {
        super.init()
        if #available(iOS 13.0, *) {
            apply(FastRoomDefaultTheme.defaultAutoTheme)
        } else {
            apply(FastRoomDefaultTheme.defaultLightTheme)
        }
    }
    
    /// You should call it before fastboard create
    @objc
    public func updateIcons(using bundle: Bundle) {
        iconsBundle = bundle
    }
    
    @objc
    public func apply(_ theme: FastRoomThemeAsset) {
        updateFastboard(theme.whiteboardAssets)
        updateControlBar(theme.controlBarAssets)
        updatePanelItem(theme.panelItemAssets)
        
        AppearanceManager.shared.commitUpdate()
    }
    
    @objc
    func updatePanelItem(_ asset: FastRoomPanelItemAssets) {
        FastRoomPanelItemButton.appearance().iconNormalColor = asset.normalIconColor
        FastRoomPanelItemButton.appearance().iconSelectedColor = asset.selectedIconColor
        FastRoomPanelItemButton.appearance().iconHighlightBgColor = asset.highlightBgColor
        FastRoomPanelItemButton.appearance().justExecutionNormalColor = asset.normalIconColor
        FastRoomPanelItemButton.appearance().highlightColor = asset.highlightColor
        FastRoomPanelItemButton.appearance().iconSelectedBgColor = asset.selectedIconBgColor
        
        UIImageView.appearance(whenContainedInInstancesOf: [FastRoomPanelItemButton.self]).tintColor = asset.subOpsIndicatorColor
        PageIndicatorLabel.appearance().configurableTextColor = asset.pageTextLabelColor
    }
    
    @objc
    func updateFastboard(_ asset: FastRoomWhiteboardAssets) {
        WhiteBoardView.appearance().backgroundColor = asset.whiteboardBackgroundColor
        FastRoomView.appearance().backgroundColor = asset.containerColor
        WhiteBoardView.appearance().themeBgColor = asset.whiteboardBackgroundColor
    }
    
    @objc
    func updateControlBar(_ asset: FastRoomControlBarAssets) {
        FastRoomControlBar.appearance().backgroundColor = asset.backgroundColor
        FastRoomControlBar.appearance().borderColor = asset.borderColor
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [FastRoomControlBar.self]).effect = asset.effectStyle
        
        SubPanelContainer.appearance().backgroundColor = asset.backgroundColor
        SubPanelContainer.appearance().borderColor = asset.borderColor
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [SubPanelContainer.self]).effect = asset.effectStyle
    }
}
