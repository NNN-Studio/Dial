//
//  ScrollController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import SFSafeSymbols

class ScrollController: DefaultController {
    static let instance: ScrollController = .init()
    
    var id: ControllerID = .builtin(.scroll)
    var name: String = NSLocalizedString("Controllers/Default/Scroll/Name", value: "Scroll", comment: "scroll controller description")
    var representingSymbol: SFSymbol = .arrowUpArrowDown
    var description: String = NSLocalizedString(
        "Controllers/Default/Scroll/Description",
        value: """
You can scroll and perform middle button clicks through this controller. Scrolls and clicks will always happen at the cursor.
""",
        comment: "scroll controller description")
    
    var rotationType: Rotation.RawType = .continuous
    
    private var accumulated = 0
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: Dial.Callback) {
        Input.postMouse(.center, buttonState: .pressed)
        Input.postMouse(.center, buttonState: .released)
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Device.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: Dial.Callback
    ) {
        var accelerated = false
        
        if let interval, interval <= 0.01 {
            if accumulated < 12 {
                accumulated += 1
            } else if duration > NSEvent.keyRepeatDelay {
                accelerated = true
            }
        } else {
            accumulated = 0
        }
        
        switch rotation {
        case .continuous(let direction):
            let steps = accelerated ? 60 : 30
            let event = CGEvent(
                scrollWheelEvent2Source: nil,
                units: .pixel,
                wheelCount: 1,
                wheel1: Int32(-steps * direction.negateIf(buttonState == .pressed).rawValue),
                wheel2: 0,
                wheel3: 0
            )
            event?.post(tap: .cghidEventTap)
        default:
            break
        }
    }
}

