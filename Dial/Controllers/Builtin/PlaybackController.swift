//
//  PlaybackController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import SFSafeSymbols
import ISSoundAdditions

class PlaybackController: BuiltinController {
    static let instance: PlaybackController = .init()
    
    var id: ControllerID = .builtin(.playback)
    var name: String? = String(localized: .init("Controllers/Default/Playback: Name", defaultValue: "Playback"))
    var symbol: SFSymbol = .speakerWave2
    
    var controllerDescription: ControllerDescription = .init(
        abstraction: .init(localized: .init("Controllers/Builtin/Playback: Abstraction", defaultValue: """
You can control system media playbacks through this controller.
""")),
        
        rotateClockwisely: .init(localized: .init("Controllers/Builtin/Playback: Rotate Clockwisely", defaultValue: """
Media forward (shortcuts 􀄫).
""")),
        rotateCounterclockwisely: .init(localized: .init("Controllers/Builtin/Playback: Rotate Counterclockwisely", defaultValue: """
Media backward (shortcuts 􀄪).
""")),
        
        press: .init(localized: .init("Controllers/Builtin/Playback: Press", defaultValue: """
Toggle system media play / pause.
""")),
        doublePress: .init(localized: .init("Controllers/Builtin/Playback: Double Press", defaultValue: """
Toggle system mute.
""")),
        
        pressAndRotateClockwisely: .init(localized: .init("Controllers/Builtin/Playback: Press and Rotate Clockwisely", defaultValue: """
System volume up.
""")),
        pressAndRotateCounterclockwisely: .init(localized: .init("Controllers/Builtin/Playback: Press and Rotate Counterclockwisely", defaultValue: """
System volume down.
"""))
    )
    
    var haptics: Bool = false
    var rotationType: Rotation.RawType = .continuous
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback) {
        if isDoubleClick {
            // Undo pause sent on first click
            Input.postAuxKeys([Input.keyPlay], modifiers: [])
            
            // Mute on double click
            Input.postAuxKeys([Input.keyMute], modifiers: [])
        } else {
            // Play / Pause on single click
            Input.postAuxKeys([Input.keyPlay], modifiers: [])
        }
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Hardware.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: SurfaceDial.Callback
    ) {
        switch rotation {
        case .continuous(let direction):
            var modifiers: NSEvent.ModifierFlags
            var action: [Hardware.ButtonState: [Direction: (aux: [Int32], normal: Set<Input>)]] = [:]
            
            switch buttonState {
            case .pressed:
                modifiers = [.shift, .option]
                action[.pressed] = [
                    .clockwise: (aux: [Input.keyVolumeUp], normal: []),
                    .counterclockwise: (aux: [Input.keyVolumeDown], normal: [])
                ]
                break
            case .released:
                modifiers = []
                action[.released] = [
                    .clockwise: (aux: [], normal: [.keyRightArrow]),
                    .counterclockwise: (aux: [], normal: [.keyLeftArrow])
                ]
                break
            }
            
            Input.postAuxKeys(action[buttonState]![direction]!.aux, modifiers: modifiers)
            Input.postKeys(action[buttonState]![direction]!.normal, modifiers: modifiers)
        default:
            break
        }
    }
}

