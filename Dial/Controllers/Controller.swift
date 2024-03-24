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
        
        static var availableCases: [ControllerID.Builtin] {
            allCases.filter { $0 != .main }
        }
    }
    
    case shortcuts(ShortcutsController.Settings)
    
    case builtin(Builtin)
    
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
            // Enables selecting current controllers
            return
        }
    }
}

extension ControllerID: Identifiable {
    /// This is intended to make `ControllerID` conforms to `Identifiable`. The return value is the same as itself.
    var id: ControllerID {
        self
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

protocol Controller: AnyObject, SymbolRepresentable {
    var id: ControllerID { get }
    
    var name: String { get }
    
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
    
    var isDefaultController: Bool {
        self is DefaultController
    }
    
    var isCurrentController: Bool {
        get {
            Defaults[.currentControllerID] == id
        }
        
        set {
            guard Defaults[.activatedControllerIDs].contains(id) else {
                Defaults[.currentControllerID] = nil
                return
            }
            
            Defaults[.currentControllerID] = id
        }
    }
    
    func equals(_ another: any Controller) -> Bool {
        Self.equals(self, another)
    }
}

extension Controller {
    var representingSymbol: SFSymbol {
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

protocol DefaultController: Controller {
    var description: String { get }
}

