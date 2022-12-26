//
//  AppearanceManager.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/6.
//

import Foundation

public class AppearanceManager: NSObject {
    @objc
    public static let shared = AppearanceManager()
    private override init() {}
    
    @objc
    public func commitUpdate() {
        let window = UIApplication.shared.keyWindow
        window?.subviews.forEach {
            $0.removeFromSuperview()
            window?.addSubview($0)
        }
    }
}
