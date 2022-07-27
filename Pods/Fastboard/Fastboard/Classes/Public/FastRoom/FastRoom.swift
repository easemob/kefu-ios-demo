//
//  Fastboard.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/29.
//

import UIKit
import Whiteboard

let pencilBehaviorUpdateNotificationName = Notification.Name("pencilBehaviorUpdateNotificationName")

/// Representing whiteboard object.
public class FastRoom: NSObject {
    /// Change this value to indicate if pencil will follow the system preference
    /// And this variable will only effect on iPad (Which has no compact sizeClass)
    /// Default is true
    @objc
    public static var followSystemPencilBehavior = true {
        didSet {
            NotificationCenter.default.post(name: pencilBehaviorUpdateNotificationName, object: nil)
        }
    }
    
    /// The view you should add to your viewController
    @objc
    public let view: FastRoomView
    
    /// The whiteSDK object, do not update it's delegate directly
    /// using 'commonDelegate' instead
    @objc
    public var whiteSDK: WhiteSDK!
    
    /// The whiteRoom object, do not update it's delegate directly
    /// using 'roomDelegate' instead
    @objc
    public var room: WhiteRoom? {
        didSet {
            if let room = room {
                view.overlay?.setupWith(room: room, fastboardView: self.view, direction: view.operationBarDirection)
                delegate?.fastboardDidSetupOverlay?(self, overlay: view.overlay)
            }
            initStateAfterJoinRoom()
            if !view.traitCollection.hasCompact {
                view.prepareForPencil()
            }
        }
    }
    
    /// The delegate of fastboard
    /// Wrapped the whiteRoom and whiteSDK event
    @objc
    public weak var delegate: FastRoomDelegate?
    
    /// Proxy for whiteSDK delegate
    @objc
    public var commonDelegate: WhiteCommonCallbackDelegate? {
        get { sdkDelegateProxy.target as? WhiteCommonCallbackDelegate }
        set { sdkDelegateProxy.target = newValue }
    }

    /// Proxy for whiteRoom delegate
    @objc
    public var roomDelegate: WhiteRoomCallbackDelegate? {
        get { roomDelegateProxy.target as? WhiteRoomCallbackDelegate }
        set { roomDelegateProxy.target = newValue }
    }
    let roomConfig: WhiteRoomConfig
    
    lazy var roomDelegateProxy = WhiteRoomCallBackDelegateProxy.target(nil, middleMan: self)
    lazy var sdkDelegateProxy = WhiteCommonCallbackDelegateProxy.target(nil, middleMan: self)
    
    // MARK: - Public
    
    /// Call the method to join the whiteRoom
    @objc public func joinRoom() {
        joinRoom(completionHandler: nil)
    }
    
    @objc
    public func disconnectRoom() {
        view.pencilHandler?.recoverApplianceFromTempRemove()
        room?.disconnect(nil)
    }
    
    @objc
    public func updateWritable(_ writable: Bool, completion: ((Error?)->Void)?) {
        room?.setWritable(writable, completionHandler: { [weak room] success, error in
            if success, writable {
                room?.disableSerialization(false)
            }
            completion?(error)
        })
    }
    
    /// Call the method to join the whiteRoom
    public func joinRoom(completionHandler: ((Result<WhiteRoom, FastRoomError>)->Void)? = nil) {
        delegate?.fastboardPhaseDidUpdate(self, phase: .connecting)
        whiteSDK.joinRoom(with: roomConfig,
                          callbacks: roomDelegateProxy) { [weak self] success, room, error in
            guard let self = self else { return }
            if let error = error {
                let fastError = FastRoomError(type: .joinRoom, error: error)
                self.delegate?.fastboardDidOccurError(self, error: fastError)
                completionHandler?(.failure(fastError))
                return
            }
            guard let room = room else {
                let fastError = FastRoomError(type: .joinRoom, info: ["info": "join success without room"])
                self.delegate?.fastboardDidOccurError(self, error: fastError)
                completionHandler?(.failure(fastError))
                return
            }
            room.disableSerialization(false)
            self.room = room
            completionHandler?(.success(room))
            self.delegate?.fastboardDidJoinRoomSuccess(self, room: room)
        }
    }
    
    // MARK: - Private
    func initStateAfterJoinRoom() {
        guard let state = room?.state else { return }
        if let appliance = state.memberState?.currentApplianceName {
            view.overlay?.updateUIWithInitAppliance(appliance, shape: state.memberState?.shapeType)
        } else {
            view.overlay?.updateUIWithInitAppliance(nil, shape: nil)
        }
        
        view.overlay?.updateBoxState(state.windowBoxState)
        
        if let pageState = state.pageState {
            view.overlay?.updatePageState(pageState)
        }
        
        if let strokeWidth = state.memberState?.strokeWidth?.floatValue {
            view.overlay?.updateStrokeWidth(strokeWidth)
        }
        
        if let nums = state.memberState?.strokeColor {
            let color = UIColor.init(numberArray: nums)
            view.overlay?.updateStrokeColor(color)
        }
    }
    
    /// Create a Fastboard with FastConfiguration
    /// - Parameter configuration: Configuration for fastboard
    @objc
    convenience init(configuration: FastRoomConfiguration) {
        func defaultOverlay() -> FastRoomOverlay {
            if UIScreen.main.traitCollection.hasCompact {
                return CompactFastRoomOverlay()
            } else {
                return RegularFastRoomOverlay()
            }
        }
        let fastboardOverlay = configuration.customOverlay ?? defaultOverlay()
        let fastboardView = FastRoomView(overlay: fastboardOverlay)
        self.init(view: fastboardView,
                  roomConfig: configuration.whiteRoomConfig,
                  sdkConfig: configuration.whiteSdkConfiguration)
    }
    
    init(view: FastRoomView,
         roomConfig: WhiteRoomConfig,
         sdkConfig: WhiteSdkConfiguration){
        self.view = view
        self.roomConfig = roomConfig
        super.init()
        let whiteSDK = WhiteSDK(whiteBoardView: view.whiteboardView,
                                config: sdkConfig,
                                commonCallbackDelegate: self.sdkDelegateProxy)
        self.whiteSDK = whiteSDK
        if !view.traitCollection.hasCompact {
            self.prepareForSystemPencilBehavior()
        }
    }
}

extension FastRoom: WhiteCommonCallbackDelegate {
    public func throwError(_ error: Error) {
    }
    
    public func sdkSetupFail(_ error: Error) {
        delegate?.fastboardDidOccurError(self, error: .init(type: .setupSDK, error: error))
    }
}

extension FastRoom: WhiteRoomCallbackDelegate {
    public func firePhaseChanged(_ phase: WhiteRoomPhase) {
        let fastPhase = FastRoomPhase(rawValue: phase.rawValue) ?? .unknown
        view.overlay?.updateRoomPhaseUpdate(fastPhase)
        delegate?.fastboardPhaseDidUpdate(self, phase: fastPhase)
    }
    
    public func fireRoomStateChanged(_ modifyState: WhiteRoomState!) {
        if let _ = modifyState.memberState {
            view.pencilHandler?.roomApplianceDidUpdate()
        }
        if let pageState = modifyState.pageState {
            view.overlay?.updatePageState(pageState)
        }
        if let boxState = modifyState.windowBoxState {
            view.overlay?.updateBoxState(boxState)
        }
    }
    
    public func fireDisconnectWithError(_ error: String!) {
        delegate?.fastboardDidOccurError(self, error: .init(type: .disconnected, info: ["info": error ?? ""]))
    }
    
    public func fireKicked(withReason reason: String!) {
        delegate?.fastboardUserKickedOut(self, reason: reason)
    }
    
    public func fireCanUndoStepsUpdate(_ canUndoSteps: Int) {
        view.overlay?.updateUndoEnable(canUndoSteps > 0)
    }
    
    public func fireCanRedoStepsUpdate(_ canRedoSteps: Int) {
        view.overlay?.updateRedoEnable(canRedoSteps > 0)
    }
}
