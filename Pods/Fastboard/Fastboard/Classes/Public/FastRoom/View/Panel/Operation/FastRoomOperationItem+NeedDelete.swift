//
//  FastRoomOperationItem+NeedDelete.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/4.
//

import Foundation
import Whiteboard

extension FastRoomOperationItem {
    var needDelete: Bool {
        func itemNeedDelete(item: FastRoomOperationItem) -> Bool {
            item.identifier == WhiteApplianceNameKey.ApplianceSelector.rawValue
        }
        if let subOps = self as? SubOpsItem,
           let item = subOps.selectedApplianceItem {
            return itemNeedDelete(item: item)
        }
        if let item = self as? ApplianceItem {
            return itemNeedDelete(item: item)
        }
        return false
    }
}
