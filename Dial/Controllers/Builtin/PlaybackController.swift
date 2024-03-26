//
//  PlaybackController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import SFSafeSymbols

class PlaybackController: DefaultController {
    static let instance: PlaybackController = .init()
    
    var id: ControllerID = .builtin(.playback)
    var name: String = String(localized: .init("Controllers/Default/Playback: Name", defaultValue: "Playback"))
    var symbol: SFSymbol = .speakerWave2
    var description: String = String(localized: .init(
        "Controllers/Default/Playback: Description",
        defaultValue: """
You can trigger forward / backward by dialing, increase / decrease volume by dialing while pressing, toggle system play / pause by single clicking, and mute / unmute by double clicking through this controller.
"""
    ))
    
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
            var action: [Hardware.ButtonState: [Direction: (aux: [Int32], normal: [Input])]] = [:]
            
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

