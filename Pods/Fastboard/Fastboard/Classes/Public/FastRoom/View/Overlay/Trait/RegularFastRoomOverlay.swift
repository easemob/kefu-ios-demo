//
//  RegularFastRoomOverlay.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/11.
//

import Foundation
import Whiteboard

/// Overlay for iPad
public class RegularFastRoomOverlay: NSObject, FastRoomOverlay, FastPanelDelegate {
    /// Indicate whether an UIActivityIndicatorView should be add to Fastboard in bad network environment
    @objc
    public static var showActivityIndicatorWhenReconnecting: Bool = true
    
    func showReconnectingView(_ show: Bool) {
        if show {
            if reconnectingView.superview == nil {
                operationPanel.view?.superview?.addSubview(reconnectingView)
                reconnectingView.frame = operationPanel.view?.superview?.bounds ?? .zero
                reconnectingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                reconnectingView.activityView.startAnimating()
            } else {
                reconnectingView.activityView.startAnimating()
            }
        } else {
            reconnectingView.removeFromSuperview()
        }
    }
    
    public func updateRoomPhaseUpdate(_ phase: FastRoomPhase) {
        guard RegularFastRoomOverlay.showActivityIndicatorWhenReconnecting else { return }
        switch phase {
        case .reconnecting:
            showReconnectingView(true)
        default:
            showReconnectingView(false)
        }
    }
    
    private var currentAppliance: ApplianceItem? {
        didSet {
            guard currentAppliance !== oldValue else { return }
            if previousAppliance !== oldValue {
                previousAppliance = oldValue
            }
        }
    }
    private var previousAppliance: ApplianceItem?
    private var exchangeForEraser: FastRoomOperationItem?
    
    @available(iOS 12.1, *)
    public func respondToPencilTap(_ tap: UIPencilPreferredAction) {
        guard let currentAppliance = currentAppliance else { return }
        func isCurrentEraser() -> Bool {
            currentAppliance.identifier?.contains(identifierFor(appliance: .ApplianceEraser, withShapeKey: nil)) ?? false
        }
        func active(item: FastRoomOperationItem, withSubPanel: Bool) {
            func performSub(_ sub: SubOpsItem) {
                sub.onClick(sub.associatedView as! UIButton)
                if !withSubPanel {
                    // Do not show panel
                    sub.subPanelView.hide()
                }
            }
            
            if let a = item as? ApplianceItem {
                a.onClick(a.button)
                return
            }
            if let sub = item as? SubOpsItem {
                performSub(sub)
                return
            }
            
        }
        
        func pencilItem() -> FastRoomOperationItem? {
            let pencilId = identifierFor(appliance: .AppliancePencil, withShapeKey: nil)
            return operationPanel.items.first(where: {
                $0.identifier?.contains(pencilId) ?? false
            })
        }
        switch tap {
        case .ignore:
            return
        case .switchEraser:
            // If is eraser
            if isCurrentEraser() {
                if let exchangeForEraser = exchangeForEraser {
                    active(item: exchangeForEraser, withSubPanel: false)
                } else {
                    if let previousAppliance = previousAppliance {
                        exchangeForEraser = previousAppliance
                        active(item: previousAppliance, withSubPanel: false)
                    } else {
                        // Set pencil as exchang
                        if let pencil = pencilItem() {
                            exchangeForEraser = pencil
                            active(item: pencil, withSubPanel: false)
                        }
                    }
                }
            } else {
                // Set exchange for eraser
                exchangeForEraser = currentAppliance
                // Switch to eraser
                if let eraser = operationPanel.items.compactMap({ $0 as? ApplianceItem }).first(where: { $0.identifier == identifierFor(appliance: .ApplianceEraser, withShapeKey: nil)}) {
                    eraser.onClick(eraser.button)
                }
            }
        case .switchPrevious:
            if let previousAppliance = previousAppliance {
                active(item: previousAppliance, withSubPanel: false)
            } else {
                if let pencil = pencilItem() {
                    active(item: pencil, withSubPanel: false)
                }
            }
        case .showColorPalette:
            func performShowColorPalette(on sub: SubOpsItem) {
                if sub.subPanelView.superview == nil {
                    sub.setupSubPanelViewHierarchy()
                    sub.subPanelView.show()
                } else {
                    if sub.subPanelView.isHidden {
                        sub.subPanelView.show()
                    } else {
                        sub.subPanelView.hide()
                    }
                }
            }
            
            if let sub = operationPanel.items.compactMap ({ $0 as? SubOpsItem }).first(where: { $0.identifier?.contains(currentAppliance.identifier ?? "") ?? false}){
                performShowColorPalette(on: sub)
            } else {
                // Select to pencil
                let pencilId = identifierFor(appliance: .AppliancePencil, withShapeKey: nil)
                if let pencil = operationPanel.items.first(where: {
                    $0.identifier?.contains(pencilId) ?? false
                }) {
                    active(item: pencil, withSubPanel: true)
                }
            }
        @unknown default:
            return
        }
    }
    
    @objc
    public func dismissAllSubPanels() {
        panels.forEach { $0.value.dismissAllSubPanels(except: nil)}
    }
    
    @objc
    public static var customOptionPanel: (()->FastRoomPanel)?
    
    @objc
    public static var shapeItems: [FastRoomOperationItem] = [
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceRectangle),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceEllipse),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceStraight),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceArrow),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceShape, shape: .ApplianceShapeTypePentagram),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceShape, shape: .ApplianceShapeTypeRhombus),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceShape, shape: .ApplianceShapeTypeTriangle),
        FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceShape, shape: .ApplianceShapeTypeSpeechBalloon)
    ]
    
    var displayStyle: DisplayStyle? {
        didSet {
            if let displayStyle = displayStyle {
                updateDisplayStyle(displayStyle)
            }
        }
    }
    
    public func invalidAllLayout() {
        allConstraints.forEach { $0.isActive = false }
        operationLeftConstraint = nil
        operationRightConstraint = nil
    }
    
    public func updateBoxState(_ state: WhiteWindowBoxState?) {
        let views = [undoRedoPanel.view, scenePanel.view]
        let hide = state == .max
        UIView.animate(withDuration: 0.3) {
            views.forEach { $0?.alpha = hide ? 0 : 1 }
        }
    }
    
    var allConstraints: [NSLayoutConstraint] = []
    var operationLeftConstraint: NSLayoutConstraint?
    var operationRightConstraint: NSLayoutConstraint?
    
    public func setupWith(room: WhiteRoom, fastboardView: FastRoomView, direction: OperationBarDirection) {
        let operationView = operationPanel.setup(room: room)
        let deleteView = deleteSelectionPanel.setup(room: room)
        let undoRedoView = undoRedoPanel.setup(room: room,
                                               direction: .horizontal)
        let sceneView = scenePanel.setup(room: room,
                                               direction: .horizontal)
        fastboardView.addSubview(operationView)
        fastboardView.addSubview(deleteView)
        fastboardView.addSubview(undoRedoView)
        fastboardView.addSubview(sceneView)
        
        let margin: CGFloat = 8
        operationLeftConstraint = operationView.leftAnchor.constraint(equalTo: fastboardView.whiteboardView.leftAnchor, constant: margin)
        operationRightConstraint = operationView.rightAnchor.constraint(equalTo: fastboardView.whiteboardView.rightAnchor, constant: -margin)
        
        let operationC0 = operationView.centerYAnchor.constraint(equalTo: fastboardView.whiteboardView.centerYAnchor)
        operationC0.isActive = true
        operationView.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteC0 = deleteView.rightAnchor.constraint(equalTo: operationView.rightAnchor)
        deleteC0.isActive = true
        let deleteC1 = deleteView.bottomAnchor.constraint(equalTo: operationView.topAnchor, constant: -margin)
        deleteC1.isActive = true
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        
        let undoRedoC0 = undoRedoView.leftAnchor.constraint(equalTo: fastboardView.whiteboardView.leftAnchor, constant: margin)
        undoRedoC0.isActive = true
        let undoRedoC1 = undoRedoView.bottomAnchor.constraint(equalTo: fastboardView.whiteboardView.bottomAnchor, constant: -margin)
        undoRedoC1.isActive = true
        undoRedoView.translatesAutoresizingMaskIntoConstraints = false
        
        let sceneC0 = sceneView.centerXAnchor.constraint(equalTo: fastboardView.whiteboardView.centerXAnchor)
        sceneC0.isActive = true
        let sceneC1 = sceneView.bottomAnchor.constraint(equalTo: fastboardView.whiteboardView.bottomAnchor, constant: -margin)
        sceneC1.isActive = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        allConstraints.append(operationLeftConstraint!)
        allConstraints.append(operationRightConstraint!)
        allConstraints.append(operationC0)
        allConstraints.append(deleteC0)
        allConstraints.append(deleteC1)
        allConstraints.append(undoRedoC0)
        allConstraints.append(undoRedoC1)
        allConstraints.append(sceneC0)
        allConstraints.append(sceneC1)
        
        updateControlBarLayout(direction: direction)
    }
    
    public func updateControlBarLayout(direction: OperationBarDirection) {
        let isLeft = direction == .left
        if isLeft {
            operationLeftConstraint?.isActive = true
            operationRightConstraint?.isActive = false
        } else {
            operationLeftConstraint?.isActive = false
            operationRightConstraint?.isActive = true
        }
    }
    
    public func updateUIWithInitAppliance(_ appliance: WhiteApplianceNameKey?, shape: WhiteApplianceShapeTypeKey?) {
        if let appliance = appliance {
            operationPanel.updateWithApplianceOutside(appliance, shape: shape)
            
            let identifier = identifierFor(appliance: appliance, withShapeKey: shape)
            
            if let item = operationPanel.flatItems.first(where: { $0.identifier == identifier }) as? ApplianceItem {
                currentAppliance = item
            }
            
            if let item = operationPanel.flatItems.first(where: { $0.identifier == identifier }) {
                updateDisplayStyleFromNewOperationItem(item)
            }
        } else {
            updateDisplayStyle(.all)
        }
    }
    
    public func updateStrokeColor(_ color: UIColor) {
        operationPanel.updateSelectedColor(color)
    }
    
    public func updateStrokeWidth(_ width: Float) {
        operationPanel.updateStrokeWidth(width)
    }
    
    public func updatePageState(_ state: WhitePageState) {
        if let label = scenePanel.items.first(where: { $0.identifier == FastRoomDefaultOperationIdentifier.operationType(.pageIndicator)!.identifier })?.associatedView as? UILabel {
            label.text = "\(state.index + 1) / \(state.length)"
            scenePanel.view?.invalidateIntrinsicContentSize()
        }
        if let last = scenePanel.items.first(where: {
            $0.identifier == FastRoomDefaultOperationIdentifier.operationType(.previousPage)!.identifier
        }) {
            (last.associatedView as? UIButton)?.isEnabled = state.index > 0
        }
        if let next = scenePanel.items.first(where: {
            $0.identifier == FastRoomDefaultOperationIdentifier.operationType(.nextPage)!.identifier
        }) {
            (next.associatedView as? UIButton)?.isEnabled = state.index + 1 < state.length
        }
    }
    
    public func updateUndoEnable(_ enable: Bool) {
        undoRedoPanel.items.first(where: { $0.identifier == FastRoomDefaultOperationIdentifier.operationType(.undo)!.identifier
        })?.setEnable(enable)
    }
    
    public func updateRedoEnable(_ enable: Bool) {
        undoRedoPanel.items.first(where: { $0.identifier == FastRoomDefaultOperationIdentifier.operationType(.redo)!.identifier
        })?.setEnable(enable)
    }
    
    public func setAllPanel(hide: Bool) {
        totalPanels.forEach { $0.view?.isHidden = hide }
        if !hide {
            if let displayStyle = displayStyle {
                updateDisplayStyle(displayStyle)
            } else {
                print("error status")
                updateDisplayStyle(.all)
            }
        }
    }
    
    public func setPanelItemHide(item: FastRoomDefaultOperationIdentifier, hide: Bool) {
        panels.values.forEach { $0.setItemHide(fromKey: item, hide: hide)}
    }
    
    public func itemWillBeExecution(fastPanel: FastRoomPanel, item: FastRoomOperationItem) {
        if let appliance = item as? ApplianceItem {
            currentAppliance = appliance
        } else if let sub = item as? SubOpsItem, sub.containsSelectableAppliance {
            currentAppliance = sub.selectedApplianceItem
        }
        
        if item is SubOpsItem {
            // Hide all the other subPanels
            panels.forEach { $0.value.dismissAllSubPanels(except: item)}
        }
        if item is ApplianceItem {
            // If is single, hide all subPanel
            // If has super, hide other subPanel
            let superItem = panels
                .map { $0.value.items }
                .flatMap { $0 }
                .compactMap { $0 as? SubOpsItem }
                .first(where: { $0.subOps.contains { s in
                    s === item
                }})
            panels.forEach { $0.value.dismissAllSubPanels(except: superItem)}
        }
        
        if item is JustExecutionItem { return }
        if item is ColorItem { return }
        if item is SliderOperationItem { return }
        if let sub = item as? SubOpsItem {
            if sub.subOps.allSatisfy({ i -> Bool in
                return i is JustExecutionItem || i is ColorItem || i is SliderOperationItem
            }) {
                return
            }
        }
        updateDisplayStyleFromNewOperationItem(item)
    }
    
    enum DisplayStyle {
        case all
        case hideDelete
    }
    
    func updateDisplayStyleFromNewOperationItem(_ item: FastRoomOperationItem) {
        if item.needDelete {
            displayStyle = .all
        } else {
            displayStyle = .hideDelete
        }
    }
    
    func updateDisplayStyle(_ style: DisplayStyle) {
        switch style {
        case .all:
            deleteSelectionPanel.view?.isHidden = false
        case .hideDelete:
            deleteSelectionPanel.view?.isHidden = true
        }
    }
    
    var totalPanels: [FastRoomPanel] { panels.map { $0.value } }
    
    lazy var panels: [PanelKey: FastRoomPanel] = [
        .operations: createOperationPanel(),
        .deleteSelection: createDeleteSelectionPanel(),
        .undoRedo: createUndoRedoPanel(),
        .scenes: createScenesPanel()
    ]
    
    lazy var reconnectingView: ReconnectingView = ReconnectingView()
}

extension RegularFastRoomOverlay {
    enum PanelKey: Equatable {
        case operations
        case deleteSelection
        case undoRedo
        case scenes
    }
    
    @objc
    public var operationPanel: FastRoomPanel { panels[.operations]! }
    
    @objc
    public var deleteSelectionPanel: FastRoomPanel { panels[.deleteSelection]! }
    
    @objc
    public var undoRedoPanel: FastRoomPanel { panels[.undoRedo]! }
    
    @objc
    public var scenePanel: FastRoomPanel { panels[.scenes]! }
    
    func createDeleteSelectionPanel() -> FastRoomPanel {
        let items: [FastRoomOperationItem] = [FastRoomDefaultOperationItem.deleteSelectionItem()]
        let panel = FastRoomPanel(items: items)
        panel.delegate = self
        return panel
    }
    
    func createUndoRedoPanel() -> FastRoomPanel {
        let ops = [FastRoomDefaultOperationItem.undoItem(), FastRoomDefaultOperationItem.redoItem()]
        let panel = FastRoomPanel(items: ops)
        panel.delegate = self
        return panel
    }
    
    func createOperationPanel() -> FastRoomPanel {
        if let panel = RegularFastRoomOverlay.customOptionPanel?() {
            panel.delegate = self
            return panel
        }
        
        var shapeOps: [FastRoomOperationItem] = RegularFastRoomOverlay.shapeItems
        shapeOps.append(FastRoomDefaultOperationItem.strokeWidthItem())
        shapeOps.append(contentsOf: FastRoomDefaultOperationItem.defaultColorItems())
        let shapes = SubOpsItem(subOps: shapeOps)
        
        var pencilSubOps: [FastRoomOperationItem] = [
            FastRoomDefaultOperationItem.selectableApplianceItem(.AppliancePencil),
            FastRoomDefaultOperationItem.strokeWidthItem()
        ]
        pencilSubOps.append(contentsOf: FastRoomDefaultOperationItem.defaultColorItems())
        let pencilOp = SubOpsItem(subOps: pencilSubOps)
        
        var textSubOps: [FastRoomOperationItem] = [
            FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceText)
        ]
        textSubOps.append(contentsOf: FastRoomDefaultOperationItem.defaultColorItems())
        let textOp = SubOpsItem(subOps: textSubOps)
        
        let ops: [FastRoomOperationItem] = [
            FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceClicker),
            FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceSelector),
            pencilOp,
            textOp,
            FastRoomDefaultOperationItem.selectableApplianceItem(.ApplianceEraser),
            shapes,
            FastRoomDefaultOperationItem.clean()
        ]
        let panel = FastRoomPanel(items: ops)
        panel.delegate = self
        return panel
    }
    
    func createScenesPanel() -> FastRoomPanel {
        let ops = [FastRoomDefaultOperationItem.previousPageItem(),
                   FastRoomDefaultOperationItem.pageIndicatorItem(),
                   FastRoomDefaultOperationItem.nextPageItem(),
                   FastRoomDefaultOperationItem.newPageItem()]
        let panel = FastRoomPanel(items: ops)
        panel.delegate = self
        return panel
    }
}
