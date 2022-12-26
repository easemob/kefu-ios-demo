//
//  FastRoomDefaultTheme.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/28.
//

import UIKit

/// Include built-in themes style for fastboard
public class FastRoomDefaultTheme: NSObject {
    @objc
    public class var defaultLightTheme: FastRoomThemeAsset {
        FastRoomThemeAsset(whiteboardAssets: FastRoomWhiteboardAssets(whiteboardBackgroundColor: .white,
                                                      containerColor: .white),
                   controlBarAssets: FastRoomControlBarAssets(backgroundColor: .white,
                                                      borderColor: .init(hexString: "#E5E8F0")),
                   panelItemAssets: .init(normalIconColor: .init(hexString: "#5D6066"),
                                          selectedIconColor: .init(hexString: "#3381FF"),
                                          selectedIconBgColor: .clear,
                                          highlightColor: .init(hexString: "#2867CC"),
                                          highlightBgColor: .clear,
                                          disableColor: .init(hexString: "#7B7E84"),
                                          subOpsIndicatorColor: .init(hexString: "#5D6066"),
                                          pageTextLabelColor: .init(hexString: "#5D6066")))
    }
    
    @objc
    public static var defaultDarkTheme: FastRoomThemeAsset {
        FastRoomThemeAsset(whiteboardAssets: FastRoomWhiteboardAssets(whiteboardBackgroundColor: .init(hexString: "#14181E"),
                                                      containerColor: .init(hexString: "#14181E")),
                   controlBarAssets: FastRoomControlBarAssets(backgroundColor: .init(hexString: "#14181E"),
                                                      borderColor: .init(hexString: "#5D6066")),
                   panelItemAssets: .init(normalIconColor: .init(hexString: "#999CA3"),
                                          selectedIconColor: .init(hexString: "#2867CC"),
                                          selectedIconBgColor: .clear,
                                          highlightColor: .init(hexString: "#1E4D99"),
                                          highlightBgColor: .clear,
                                          disableColor: .init(hexString: "#4B4D54"),
                                          subOpsIndicatorColor: .init(hexString: "#999CA3"),
                                          pageTextLabelColor: .init(hexString: "#999CA3")))
    }
    
    @available(iOS 13, *)
    @objc
    public static var defaultAutoTheme: FastRoomThemeAsset {
        let fastAsset = FastRoomWhiteboardAssets(whiteboardBackgroundColor: .systemBackground, containerColor: .secondarySystemBackground)
        let controlBarAssets = FastRoomControlBarAssets(backgroundColor: .clear, borderColor: .separator, effectStyle: .init(style: .systemMaterial))
        let panelItemAssets = FastRoomPanelItemAssets(normalIconColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.normalIconColor
            } else {
                return defaultLightTheme.panelItemAssets.normalIconColor
            }
        }), selectedIconColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.selectedIconColor
            } else {
                return defaultLightTheme.panelItemAssets.selectedIconColor
            }
        }), selectedIconBgColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.selectedIconBgColor
            } else {
                return defaultLightTheme.panelItemAssets.selectedIconBgColor
            }
        }), highlightColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.highlightColor
            } else {
                return defaultLightTheme.panelItemAssets.highlightColor
            }
        }), highlightBgColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.highlightBgColor
            } else {
                return defaultLightTheme.panelItemAssets.highlightBgColor
            }
        }), disableColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.disableColor
            } else {
                return defaultLightTheme.panelItemAssets.disableColor
            }
        }), subOpsIndicatorColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.subOpsIndicatorColor
            } else {
                return defaultLightTheme.panelItemAssets.subOpsIndicatorColor
            }
        }), pageTextLabelColor: .init(dynamicProvider: { c in
            if c.userInterfaceStyle == .dark {
                return defaultDarkTheme.panelItemAssets.pageTextLabelColor
            } else {
                return defaultLightTheme.panelItemAssets.pageTextLabelColor
            }
        }))
        
        return FastRoomThemeAsset(whiteboardAssets: fastAsset,
                   controlBarAssets: controlBarAssets,
                          panelItemAssets: panelItemAssets
        )
    }
}
