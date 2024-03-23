//
//  SurfaceDial.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import SFSafeSymbols
import Defaults
import AppKit
import Cocoa
import SwiftUI

@Observable class SurfaceDial {
    static var instance: SurfaceDial = .init()
    
    var hardware: Hardware = .init()
    
    /*
    var window: DialWindow = .init(
        styleMask: [.borderless],
        backing: .buffered,
        defer: true
    )
     */
    
    var controller: Controller? {
        MainController.instance.isAgent ? MainController.instance : Defaults.currentController
    }
    
    private var timestamps: (
        buttonPressed: Date?,
        buttonReleased: Date?,
        rotation: Date?
    )
    
    private var rotationBehavior: (
        started: Date?,
        direction: Direction,
        degrees /* 360 per circle, positive values represent clockwise rotation */ : Int
    ) = (started: nil, direction: .clockwise, degrees: 0)
    
    init() {
        hardware.inputHandler = self
        MainController.instance.callback = .init(self)
        
        connect()
    }
}

extension SurfaceDial {
    func connect() {
        hardware.start()
    }
    
    func disconnect() {
        hardware.stop()
    }
}

extension SurfaceDial: InputHandler {
    func onButtonStateChanged(_ buttonState: Hardware.ButtonState) {
        let pressInterval = Date.now.timeIntervalSince(timestamps.buttonPressed)
        let releaseInterval = Date.now.timeIntervalSince(timestamps.buttonReleased)
        
        rotationBehavior.started = nil
        rotationBehavior.degrees = 0
        
        switch buttonState {
        case .pressed:
            // Trigger press and hold
            if !MainController.instance.isAgent {
                MainController.instance.willBeAgent()
            }
            
            timestamps.buttonPressed = .now
        case .released:
            MainController.instance.discardUpcomingAgentRole()
            
            let clickInterval = Date.now.timeIntervalSince(timestamps.buttonPressed)
            guard let clickInterval, clickInterval <= NSEvent.doubleClickInterval else {
                controller?.onRelease(callback)
                break
            }
            
            if let releaseInterval, releaseInterval <= NSEvent.doubleClickInterval {
                // Double click
                controller?.onClick(isDoubleClick: true, interval: releaseInterval, callback)
                timestamps.buttonReleased = nil
            } else {
                // Click
                controller?.onClick(isDoubleClick: false, interval: releaseInterval, callback)
                timestamps.buttonReleased = .now
            }
        }
    }
    
    func onRotation(_ direction: Direction, _ buttonState: Hardware.ButtonState) {
        MainController.instance.discardUpcomingAgentRole()
        
        let interval = Date.now.timeIntervalSince(timestamps.rotation)
        if let interval, interval > NSEvent.keyRepeatDelay {
            // Rotation ended
            rotationBehavior.started = nil
            rotationBehavior.degrees = 0
            
            print("Rotation ended.")
        }
        
        let lastStage = (
            stepping: Int(CGFloat(rotationBehavior.degrees) / Defaults[.globalSensitivity].gap),
            continuous: Int(CGFloat(rotationBehavior.degrees) / Defaults[.globalSensitivity].flow)
        )
        rotationBehavior.degrees += direction.rawValue
        let currentStage = (
            stepping: Int(CGFloat(rotationBehavior.degrees) / Defaults[.globalSensitivity].gap),
            continuous: Int(CGFloat(rotationBehavior.degrees) / Defaults[.globalSensitivity].flow)
        )
        
        if let duration = Date.now.timeIntervalSince(rotationBehavior.started) {
            if lastStage.continuous != currentStage.continuous {
                // Continuous rotation
                controller?.onRotation(
                    rotation: .continuous(direction), totalDegrees: rotationBehavior.degrees,
                    buttonState: buttonState, interval: interval, duration: duration,
                    callback
                )
            }
            
            if lastStage.stepping != currentStage.stepping {
                // Stepping rotation
                controller?.onRotation(
                    rotation: .stepping(direction), totalDegrees: rotationBehavior.degrees,
                    buttonState: buttonState, interval: interval, duration: duration,
                    callback
                )
            }
            
            if rotationBehavior.direction != direction {
                rotationBehavior.direction = direction
                rotationBehavior.started = .now
            }
        } else {
            // Check threshold
            let started = rotationBehavior.degrees.magnitude > 10
            if started {
                print("Rotation started.")
                
                rotationBehavior.started = .now
            }
        }
        
        timestamps.rotation = .now
    }
}

extension SurfaceDial {
    var callback: Callback {
        Callback(self)
    }
    
    struct Callback {
        private var dial: SurfaceDial
        
        init(_ dial: SurfaceDial) {
            self.dial = dial
        }
        
        var device: Hardware.Callback {
            dial.hardware.callback
        }
        
        /*
        var window: DialWindow {
            dial.window
        }
         */
    }
}

