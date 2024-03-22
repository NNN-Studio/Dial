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

class MainController: ObservableObject, Controller {
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
    
    static var instance: MainController = .init()
    
    var id: ControllerID = .builtin(.main)
    var name: String = NSLocalizedString("Controllers/Default/Main/Name", value: "Main", comment: "main controller")
    var representingSymbol: SFSymbol = .hockeyPuck
    
    var haptics: Bool = false
    var rotationType: Rotation.RawType = .stepping
    var callback: SurfaceDial.Callback?
    
    var isAgent: Bool {
        get {
            state.isAgent
        }
        
        set {
            state = newValue ? .agentPressing : .notAgent
        }
    }
    
    @Published var state: State = .notAgent
    private var dispatch: DispatchWorkItem?
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback) {
        discardAgentRole()
    }
    
    func onRelease(_ callback: SurfaceDial.Callback) {
        if state == .agentPressing {
            state = .agentReleased
        } else if state == .agentPressingRotated {
            discardAgentRole()
        }
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Hardware.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: SurfaceDial.Callback
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

