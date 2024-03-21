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

extension Date {
    func timeIntervalSince(
        _ date: Date?
    ) -> TimeInterval? {
        if let date {
            return timeIntervalSince(date)
        } else {
            return nil
        }
    }
}

enum ControllerID: Codable, Equatable, Defaults.Serializable, Hashable {
    enum Default: CaseIterable, Codable {
        case main
        
        case scroll
        
        case playback
        
        case mission
        
        case brightness
        
        static var availableCases: [ControllerID.Default] {
            allCases.filter { $0 != .main }
        }
    }
    
    case id(UUID)
    
    case `default`(Default)
    
    public static let pasteboardType = NSPasteboard.PasteboardType("dial.controllerid")
}

protocol Controller: AnyObject, SymbolRepresentable {
    var id: ControllerID { get }
    
    var name: String { get }
    
    /// Whether to enable haptic feedback on stepping. The default value is `false`.
    var haptics: Bool { get }
    
    var rotationType: Rotation.RawType { get }
    
    var autoTriggers: Bool { get }
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: Dial.Callback)
    
    func onRotation(rotation: Rotation, totalDegrees: Int, buttonState: Device.ButtonState, interval: TimeInterval?, duration: TimeInterval, _ callback: Dial.Callback)
    
    func onRelease(_ callback: Dial.Callback)
}

extension Controller {
    var isDefaultController: Bool {
        self is DefaultController
    }
}

extension Controller {
    var representingSymbol: SFSymbol {
        .circleFillableFallback
    }
    
    var haptics: Bool {
        false
    }
    
    var autoTriggers: Bool {
        haptics && rotationType.autoTriggers
    }
    
    func onRelease(_ callback: Dial.Callback) {
        
    }
}

protocol DefaultController: Controller {
    var description: String { get }
}

