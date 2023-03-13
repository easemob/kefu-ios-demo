//
//  DefaultOperationItem.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/31.
//

import Foundation
import Whiteboard
import UIKit

/// Include built-in operationItems
@objc
public class FastRoomDefaultOperationItem: NSObject {
    @objc
    public static var defaultColors: [UIColor] = [
        .init(hexString: "#EC3455"),
        .init(hexString: "#F5AD46"),
        .init(hexString: "#68AB5D"),
        .init(hexString: "#32C5FF"),
        .init(hexString: "#005BF6"),
        .init(hexString: "#6236FF"),
        .init(hexString: "#9E51B6"),
        .init(hexString: "#6D7278")
    ]
    
    static func defaultColorItems() -> [FastRoomOperationItem] {
        defaultColors.map { ColorItem(color: $0) }
    }
    
    @objc
    public static func clean() -> FastRoomOperationItem {
        let image = UIImage.currentBundle(named: "whiteboard_clean")!
        return JustExecutionItem(
            image: image,
            action: { room, _ in room.cleanScene(true) },
            identifier: FastRoomDefaultOperationIdentifier.operationType(.clean)!.identifier)
    }
    
    @objc
    public static func deleteSelectionItem() -> FastRoomOperationItem {
        let image = UIImage.currentBundle(named: "whiteboard_remove_selection")?.redraw(.systemRed)
        return JustExecutionItem(image: image!,
                          action: { room, _ in room.deleteOperation() },
                                 identifier: FastRoomDefaultOperationIdentifier.operationType(.deleteSelection)!.identifier)
    }
    
    @objc
    public static func strokeWidthItem() -> FastRoomOperationItem {
        SliderOperationItem(value: 0,
                            action: { room, s in
            guard let s = s as? Float else { return }
            let memberState = WhiteMemberState()
            memberState.strokeWidth = NSNumber(value: s)
            room.setMemberState(memberState)
        }, sliderConfig: { slider in
            slider.minimumValue = 1
            slider.maximumValue = 20
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.strokeWidth)!.identifier)
    }
    
    @objc
    public static func redoItem() -> FastRoomOperationItem {
        let item = JustExecutionItem(image: UIImage.currentBundle(named: "whiteboard_redo")!,
                          action: { room, _ in
            room.redo()
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.redo)!.identifier)
        item.button.isEnabled = false
        return item
    }
    
    @objc
    public static func undoItem() -> FastRoomOperationItem {
        let item = JustExecutionItem(image: UIImage.currentBundle(named: "whiteboard_undo")!,
                          action: { room, _ in
            room.undo()
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.undo)!.identifier)
        item.button.isEnabled = false
        return item
    }
    
    @objc
    public static func previousPageItem() -> FastRoomOperationItem {
        JustExecutionItem(image: UIImage.currentBundle(named: "scene_previous")!,
                          action: { room, _ in
            room.prevPage(nil)
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.previousPage)!.identifier)
    }
    
    @objc
    public static func nextPageItem() -> FastRoomOperationItem {
        JustExecutionItem(image: UIImage.currentBundle(named: "scene_next")!,
                          action: { room, _ in
            room.nextPage(nil)
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.nextPage)!.identifier)
    }
    
    @objc
    public static func newPageItem() -> FastRoomOperationItem {
        JustExecutionItem(image: UIImage.currentBundle(named: "scene_new")!,
                          action: { room, _ in
            room.addPage()
            room.nextPage(nil)
        }, identifier: FastRoomDefaultOperationIdentifier.operationType(.newPage)!.identifier)
    }
    
    @objc
    public static func selectableApplianceItem(_ appliance: WhiteApplianceNameKey,
                                               shape: WhiteApplianceShapeTypeKey? = nil) -> FastRoomOperationItem {
        var imageName = "whiteboard_"
        if appliance == .ApplianceShape, let shape = shape {
            imageName = imageName + "shape_\(shape.rawValue)"
        } else {
            imageName += appliance.rawValue
        }
        let identifier = identifierFor(appliance: appliance, shape: shape)
        return ApplianceItem(image: UIImage.currentBundle(named: imageName)!, selectedImage: UIImage.currentBundle(named: imageName + "-selected"), action: { room, _ in
            let memberState = WhiteMemberState()
            memberState.currentApplianceName = appliance
            memberState.shapeType = shape
            room.setMemberState(memberState)
        }, identifier: identifier)
    }
    
    @objc
    public static func pageIndicatorItem() -> FastRoomOperationItem {
        let label = PageIndicatorLabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return IndicatorItem(view: label,
                             identifier: FastRoomDefaultOperationIdentifier.operationType(.pageIndicator)!.identifier)
    }
}

func identifierFor(appliance: WhiteApplianceNameKey, shape: WhiteApplianceShapeTypeKey?) -> String {
    FastRoomDefaultOperationIdentifier.applice(key: appliance, shape: shape).identifier
}
