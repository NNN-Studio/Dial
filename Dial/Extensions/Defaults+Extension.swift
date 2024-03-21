//
//  Defaults+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Defaults

extension Defaults.Keys {
    static let haptics = Key<Bool>("haptics", default: true)
    static let statusItem = Key<Bool>("statusItem", default: true)
    static let statusItemAutoHidden = Key<Bool>("statusItemAutoHidden", default: false)
    
    static let globalSensitivity = Key<Sensitivity>("globalSensitivity", default: .natural)
    static let globalDirection = Key<Direction>("globalDirection", default: .clockwise)
    
    static let controllers: Key<[ControllerID: Bool]> = {
        Task { @MainActor in
            print("Task started: validating controller indexes")
            
            for await controllers in Defaults.updates(.controllers) {
                if controllers.isEmpty {
                    // Not selectable
                    Defaults[.currentControllerIndex] = nil
                    Defaults[.selectedControllerIndex] = nil
                } else {
                    if let current = Defaults[.currentControllerIndex] {
                        // Make sure the index is valid
                        Defaults[.currentControllerIndex] = max(0, min(controllers.count, current))
                    } else {
                        // The index is `nil`, reset it
                        Defaults[.currentControllerIndex] = 0
                    }
                    
                    if let selected = Defaults[.selectedControllerIndex] {
                        if selected < 0 || selected >= controllers.count {
                            // Sets to `nil` if the index is invalid
                            Defaults[.selectedControllerIndex] = nil
                        }
                    }
                }
            }
        }
        
        return .init("controllers", default: [
            .builtin(.scroll): true,
            .builtin(.playback): true,
            .builtin(.brightness): true,
            .builtin(.mission): true
        ])
    }()
    static let currentControllerIndex = Key<Int?>("currentControllerIndex", default: 0)
    static let selectedControllerIndex = Key<Int?>("selectedControllerIndex", default: nil)
}
