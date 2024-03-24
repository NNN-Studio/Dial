//
//  Defaults+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let globalHapticsEnabled = Key<Bool>("hapticsEnabled", default: true)
    static let menuBarItemEnabled = Key<Bool>("menuBarItemEnabled", default: true)
    static let menuBarItemAutoHidden = Key<Bool>("menuBarItemAutoHidden", default: false)
    
    static let globalSensitivity = Key<Sensitivity>("globalSensitivity", default: .natural)
    static let globalDirection = Key<Direction>("globalDirection", default: .clockwise)
    
    static let controllerStates: Key<[ControllerState]> = {
        Task { @MainActor in
            print("Task started: validating controller indexes")
            
            for await controllers in Defaults.updates(.controllerStates) {
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
            .init(.builtin(.scroll), true),
            .init(.builtin(.playback), true),
            .init(.builtin(.brightness), true),
            .init(.builtin(.mission), true)
        ])
    }()
    static let currentControllerIndex = Key<Int?>("currentControllerIndex", default: nil)
    static let selectedControllerIndex = Key<Int?>("selectedControllerIndex", default: nil)
    
    // MARK: - Constants
    
    static let maxControllers = Key<Int>("maxControllers", default: 10)
}

struct ControllerState: Codable, Hashable, Identifiable, Equatable, Defaults.Serializable {
    var id: ControllerID
    var isOn: Bool
    
    init(_ id: ControllerID, _ isOn: Bool) {
        self.id = id
        self.isOn = isOn
    }
    
    func with(_ isOn: Bool) -> Self {
        .init(self.id, isOn)
    }
}

extension Defaults {
    static var activatedControllerStates: [ControllerState] {
        get {
            Defaults[.controllerStates]
                .filter(\.isOn)
                .map { $0.with($0.id == currentControllerID) }
        }
        
        set {
            let differences = newValue
                .filter(\.isOn)
                .filter { !activatedControllerStates.filter(\.isOn).contains($0) }
            guard
                differences.count == 1,
                let controllerID = differences.first?.id
            else { return }
            
            Defaults[.currentControllerIndex] = controllerIDs.firstIndex(of: controllerID)
            print(controllerID)
        }
    }
    
    static var controllerIDs: [ControllerID] {
        Defaults[.controllerStates].map { $0.id }
    }
    
    static var currentControllerID: ControllerID? {
        guard let index = Defaults[.currentControllerIndex] else { return nil }
        return controllerIDs[index]
    }
    
    static var currentController: Controller? {
        currentControllerID?.controller
    }
    
    static var selectedControllerID: ControllerID? {
        guard let index = Defaults[.selectedControllerIndex] else { return nil }
        return controllerIDs[index]
    }
    
    static var selectedController: Controller? {
        selectedControllerID?.controller
    }
    
    static func cycleControllers(_ sign: Int, wrap: Bool = false) {
        guard sign != 0 else { return }
        guard let index = Defaults[.currentControllerIndex] else { return }
        
        let cycledIndex = index + sign.signum()
        let count = controllerIDs.count
        let inRange = NSRange(location: 0, length: count).contains(cycledIndex)
        
        if wrap || inRange {
            Defaults[.currentControllerIndex] = (cycledIndex + count) % count
            // TODO: Buzz
        }
    }
}
