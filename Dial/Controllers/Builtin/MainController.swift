//
//  MainController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import SFSafeSymbols
import AppKit
import Defaults

@Observable class MainController: Controller {
    static var instance: MainController = .init()
    
    var id: ControllerID = .builtin(.main)
    var name: String = NSLocalizedString("Controllers/Default/Main/Name", value: "Main", comment: "main controller")
    var representingSymbol: SFSymbol = .hockeyPuck
    
    var haptics: Bool = false
    var rotationType: Rotation.RawType = .stepping
    var callback: Dial.Callback?
    
    var isAgent: Bool {
        get {
            state.isAgent
        }
        
        set {
            state = newValue ? .agentPressing : .notAgent
        }
    }
    
    var state: State = .notAgent
    private var dispatch: DispatchWorkItem?
    
    enum State {
        
        case agentPressing
        
        case agentPressingRotated
        
        case agentReleased
        
        case notAgent
        
        var isAgent: Bool {
            switch self {
            case .notAgent:
                false
            default:
                true
            }
        }
        
    }
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: Dial.Callback) {
        discardAgentRole()
    }
    
    func onRelease(_ callback: Dial.Callback) {
        if state == .agentPressing {
            state = .agentReleased
        } else if state == .agentPressingRotated {
            discardAgentRole()
        }
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Device.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: Dial.Callback
    ) {
        if state == .agentPressing {
            state = .agentPressingRotated
        }
        
        switch rotation {
        case .continuous(_):
            break
        case .stepping(let direction):
            Defaults.cycleControllers(direction.physical.negate.rawValue, wrap: Defaults.controllerIDs.count == Defaults[.maxControllers])
        }
    }
    
    func willBeAgent() {
        dispatch = .init {
            self.isAgent = true
            //self.callback?.window.show()
            self.callback?.device.buzz()
            self.callback?.device.initSensitivity(autoTriggers: false)
            
            print("Main controller is now the agent.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + NSEvent.doubleClickInterval, execute: dispatch!)
    }
    
    func discardUpcomingAgentRole() {
        dispatch?.cancel()
    }
    
    func discardAgentRole() {
        discardUpcomingAgentRole()
        
        if isAgent {
            isAgent = false
            //self.callback?.window.hide()
            self.callback?.device.initSensitivity(autoTriggers: Defaults.currentController?.autoTriggers ?? false)
            
            print("Main controller is no longer the agent.")
        }
    }
}

