//
//  DefaultOperationType.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/11.
//

import Foundation
import Whiteboard

@objc
public enum FastRoomDefaultOperationType: Int {
    case appliance = 0
    case shape
    case color
    case deleteSelection
    case strokeWidth
    case clean
    case redo
    case undo
    case newPage
    case previousPage
    case nextPage
    case pageIndicator
    
    var identifier: String {
        switch self {
        case .appliance: return "appliance"
        case .shape: return "shape"
        case .color: return "color"
        case .deleteSelection: return "deleteSelection"
        case .strokeWidth: return "strokeWidth"
        case .clean: return "clean"
        case .redo: return "redo"
        case .undo: return "undo"
        case .newPage: return "newPage"
        case .previousPage: return "previousPage"
        case .nextPage: return "nextPage"
        case .pageIndicator: return "pageIndicator"
        }
    }
}

@objc
public class FastRoomDefaultOperationIdentifier: NSObject {
    private override init() {
        self.type = .appliance
        super.init()
    }
    private init(type: FastRoomDefaultOperationType) {
        self.type = type
    }
    let type: FastRoomDefaultOperationType
    var appliance: WhiteApplianceNameKey? = nil
    var shape: WhiteApplianceShapeTypeKey? = nil
    var color: UIColor? = nil
    
    @objc
    public var identifier: String {
        if let shape = shape {
            return shape.rawValue
        } else if let appliance = appliance {
            return appliance.rawValue
        } else if let color = color {
            return color.getNumbersArray().description
        } else {
            return type.identifier
        }
    }
    
    var selectable: Bool {
        switch self.type {
        case .appliance: return true
        default: return false
        }
    }
    
    @objc
    public class func applice(key: WhiteApplianceNameKey, shape: WhiteApplianceShapeTypeKey?) -> FastRoomDefaultOperationIdentifier {
        let instance = FastRoomDefaultOperationIdentifier(type: .appliance)
        instance.appliance = key
        instance.shape = shape
        return instance
    }
    
    @objc
    public class func color(_ color: UIColor) -> FastRoomDefaultOperationIdentifier {
        let instance = FastRoomDefaultOperationIdentifier(type: .color)
        instance.color = color
        return instance
    }
    
    @objc
    public class func operationType(_ type: FastRoomDefaultOperationType) -> FastRoomDefaultOperationIdentifier? {
        switch type {
        case .appliance, .color:
            print("Use other init function instead of ",  #function)
            return nil
        default:
            return FastRoomDefaultOperationIdentifier(type: type)
        }
    }
}
