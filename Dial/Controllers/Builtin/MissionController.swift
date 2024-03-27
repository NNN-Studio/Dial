//
//  MissionController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import SFSafeSymbols

class MissionController: BuiltinController {
    static let instance: MissionController = .init()
    
    var id: ControllerID = .builtin(.mission)
    var name: String = String(localized: .init("Controllers/Default/Mission: Name", defaultValue: "Mission"))
    var symbol: SFSymbol = .command
    var description: String = String(localized: .init(
        "Controllers/Default/Mission: Description",
        defaultValue: """
You can iterate through App Switcher and activate the app windows through this controller.
"""
    ))
    
    
    var haptics: Bool = true
    var rotationType: Rotation.RawType = .stepping
    
    private var inMission = false
    private var escapeDispatch: DispatchWorkItem?
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback) {
        if !isDoubleClick {
            onRelease(callback)
        }
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Hardware.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: SurfaceDial.Callback
    ) {
        switch rotation {
        case .stepping(let direction):
            escapeDispatch?.cancel()
            inMission = true
            
            let modifiers: [Direction: NSEvent.ModifierFlags] = [.clockwise: [.command], .counterclockwise: [.shift, .command]]
            let action: [Direction: [Input]] = [.clockwise: [.keyTab], .counterclockwise: [.keyTab]]
            
            Input.postKeys(action[direction]!, modifiers: modifiers[direction]!)
            
            escapeDispatch = DispatchWorkItem {
                Input.keyEscape.post()
            }
            if let escapeDispatch {
                DispatchQueue.main.asyncAfter(deadline: .now() + NSEvent.doubleClickInterval * 3, execute: escapeDispatch)
            }
            
            callback.device.buzz()
        default:
            break
        }
    }
    
    func onRelease(_ callback: SurfaceDial.Callback) {
        if inMission {
            inMission = false
            escapeDispatch?.cancel()
            
            Input.keyReturn.post()
        }
    }
}

