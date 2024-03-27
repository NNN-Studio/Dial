//
//  Controller.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import Defaults
import SFSafeSymbols
import SwiftUI

let newControllerName: String = String(localized: .init("New Controller"))

enum ControllerID: Codable, Hashable, Defaults.Serializable, Equatable {
    enum Builtin: CaseIterable, Codable {
        case main
        
        case scroll
        
        case playback
        
        case brightness
        
        case mission
        
        var controller: Controller {
            switch self {
            case .main:
                MainController.instance
            case .scroll:
                ScrollController.instance
            case .playback:
                PlaybackController.instance
            case .brightness:
                BrightnessController.instance
            case .mission:
                MissionController.instance
            }
        }
        
        var linkage: ControllerID {
            .builtin(self)
        }
        
        static var availableCases: [ControllerID.Builtin] {
            allCases.filter { $0 != .main }
        }
    }
    
    case shortcuts(ShortcutsController.Settings)
    
    case builtin(Builtin)
}

extension ControllerID {
    var controller: Controller {
        get {
            switch self {
            case .shortcuts(let settings):
                ShortcutsController(settings: settings)
            case .builtin(let builtin):
                builtin.controller
            }
        }
        
        set(controller) {
            // Enable binding operations
            guard let shortcutsController = controller as? ShortcutsController else { return }
            
            if Defaults[.activatedControllerIDs].contains(self) {
                Defaults[.activatedControllerIDs].replace([self], with: [Self.shortcuts(shortcutsController.settings)])
            }
            
            if Defaults[.nonactivatedControllerIDs].contains(self) {
                Defaults[.nonactivatedControllerIDs].replace([self], with: [Self.shortcuts(shortcutsController.settings)])
            }
        }
    }
    
    var isCurrent: Bool {
        get {
            Defaults[.currentControllerID] == self
        }
        
        set {
            guard Defaults[.activatedControllerIDs].contains(self) else {
                Defaults[.currentControllerID] = nil
                return
            }
            
            Defaults[.currentControllerID] = self
        }
    }
    
    var isBuiltin: Bool {
        switch self {
        case .shortcuts(_):
            false
        case .builtin(_):
            true
        }
    }
    
    var isActivated: Bool {
        get {
            Defaults[.activatedControllerIDs].contains(self)
        }
        
        set(activated) {
            if activated && !isActivated {
                Defaults[.activatedControllerIDs].append(self)
                Defaults[.nonactivatedControllerIDs].replace([self], with: [])
            }
            
            if !activated && isActivated {
                Defaults[.activatedControllerIDs].replace([self], with: [])
                Defaults[.nonactivatedControllerIDs].append(self)
            }
        }
    }
}

extension ControllerID: Identifiable {
    /// This is intended to make `ControllerID` conforms to `Identifiable`. The return value is the same as itself.
    var id: Self {
        self
    }
}

extension ControllerID.Builtin: Identifiable {
    /// This is intended to make `ControllerID.Builtin` conforms to `Identifiable`. The return value is the same as itself.
    var id: Self {
        self
    }
}

extension ControllerID: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .shortcuts(_):
            "Shortcuts<\(self)>"
        case .builtin(let builtin):
            "Builtin<\(String(reflecting: builtin))>"
        }
    }
}

extension ControllerID: LosslessStringConvertible {
    init?(_ description: String) {
        guard let data = description.data(using: .utf8) else { return nil }
        guard let id = try? JSONDecoder().decode(ControllerID.self, from: data.base64EncodedData()) else { return nil }
        self = id
    }
    
    var description: String {
        let data = try! JSONEncoder().encode(self)
        return data.base64EncodedString()
    }
}

extension ControllerID: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .controllerID) { id in
            try JSONEncoder().encode(id).base64EncodedData()
        } importing: { data in
            try JSONDecoder().decode(ControllerID.self, from: data)
        }
    }
}

protocol Controller: AnyObject, SymbolRepresentable {
    var id: ControllerID { get }
    
    var name: String { get set }
    
    /// Whether to enable haptic feedback on stepping. The default value is `false`.
    var haptics: Bool { get }
    
    var rotationType: Rotation.RawType { get }
    
    var autoTriggers: Bool { get }
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback)
    
    func onRotation(rotation: Rotation, totalDegrees: Int, buttonState: Hardware.ButtonState, interval: TimeInterval?, duration: TimeInterval, _ callback: SurfaceDial.Callback)
    
    func onRelease(_ callback: SurfaceDial.Callback)
}

extension Controller {
    static func equals(_ lhs: any Controller, _ rhs: any Controller) -> Bool {
        lhs.id == rhs.id
    }
    
    func equals(_ another: any Controller) -> Bool {
        Self.equals(self, another)
    }
}

extension Controller {
    var symbol: SFSymbol {
        .__circleFillableFallback
    }
    
    var haptics: Bool {
        false
    }
    
    var autoTriggers: Bool {
        haptics && rotationType.autoTriggers
    }
    
    func onRelease(_ callback: SurfaceDial.Callback) {
        
    }
}

protocol BuiltinController: Controller {
    var description: String { get }
}

