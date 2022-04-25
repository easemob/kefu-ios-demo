//
//  FastRoomOperationItem+NeedColor.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/4.
//

import Foundation
import Whiteboard

extension FastRoomOperationItem {
    var needColor: Bool {
        func applianceNeedColor(_ item: ApplianceItem) -> Bool {
            let needColorKeys: [WhiteApplianceNameKey] = [
                .AppliancePencil,
                .ApplianceText,
                .ApplianceEllipse,
                .ApplianceRectangle,
                .ApplianceStraight,
                .ApplianceArrow,
                .ApplianceShape
            ]
            return needColorKeys.map { $0.rawValue }.contains(item.identifier!)
        }
        if let subOps = self as? SubOpsItem,
           let appliance = subOps.selectedApplianceItem {
            return applianceNeedColor(appliance)
        }
        if let item = self as? ApplianceItem {
            return applianceNeedColor(item)
        }
        return false
    }
}
