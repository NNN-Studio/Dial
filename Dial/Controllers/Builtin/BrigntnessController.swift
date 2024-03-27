//
//  BrigntnessController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import SFSafeSymbols
import AppKit

class BrightnessController: BuiltinController {
    static let instance: BrightnessController = .init()
    
    var id: ControllerID = .builtin(.brightness)
    var name: String = String(localized: .init("Controllers/Default/Brigshtnes: Name", defaultValue: "Brightness"))
    var symbol: SFSymbol = .sunMax
    var description: String = String(localized: .init(
        "Controllers/Default/Brigshtnes: Description",
        defaultValue: """
You can increase / decrease screen brightness by dialing, increase / decrease keyboard backlighting by dialing while pressing, and toggle keyboard backlighting by clicking through this controller.
"""
    ))
    
    var rotationType: Rotation.RawType = .continuous
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback) {
        Input.postAuxKeys([Input.keyIlluminationToggle])
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
                    .clockwise: (aux: [Input.keyBrightnessUp], normal: []),
                    .counterclockwise: (aux: [Input.keyBrightnessDown], normal: [])
                ]
                break
            case .released:
                modifiers = []
                action[.released] = [
                    .clockwise: (aux: [Input.keyIlluminationUp], normal: []),
                    .counterclockwise: (aux: [Input.keyIlluminationDown], normal: [])
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

