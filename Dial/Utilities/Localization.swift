//
//  Localization.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation

protocol Localizable: Codable {
    /// A name. Should be something like `This is a name`.
    var localizedName: String { get }
    
    /// A title. Should be something like `This is a Title with More Words Capitalized`. Defaults to `name`,
    var localizedTitle: String { get }
    
    /// A badge. Should be something like `this is a badge with all non-capital letters`. Defaults to `name`,
    var localizedBadge: String { get }
    
}

extension Localizable {
    var localizedTitle: String {
        localizedName
    }
    
    var localizedBadge: String {
        localizedName
    }
}

enum Localization: Codable {
    case openSettings
    
    case quit
    
    case shortcutsNameFormat
    
    enum ConnectionStatus: Codable {
        case on
        
        case off
        
        case offBadge
        
        case offPlaceholder
    }
    
    enum General: Codable {
        case sensitivity
        
        case direction
        
        case haptics
        
        case autoHidesIcon
        
        case startsWithMacOS
    }
    
    struct Controllers {
        enum Shortcuts: Codable {
            
            case idle
            
            case cancellable
            
        }
        
        enum Advanced: Codable {
            case rotationType
            
            case haptics
            
            case physicalDirection
            
            case alternativeDirection
        }
    }
}

extension Localization: Localizable {
    var localizedName: String {
        switch self {
        case .openSettings:
            NSLocalizedString("OpenSettings.Name", value:"Settings...", comment: "open settings")
        case .quit:
            NSLocalizedString("Quit.Name", value:"Quit app", comment: "quit")
        case .shortcutsNameFormat:
            NSLocalizedString(
                "Controllers/Shortcuts/Fallback.Name",
                value: "Controller %lld",
                comment: "shortcuts controller fallback"
            )
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .openSettings:
            NSLocalizedString("OpenSettings.Title", value:"Settings...", comment: "open settings")
        case .quit:
            NSLocalizedString("Quit.Title", value:"Quit App", comment: "quit")
        case .shortcutsNameFormat:
            NSLocalizedString(
                "Controllers/Shortcuts/Fallback.Title",
                value: "Controller %lld",
                comment: "shortcuts controller fallback"
            )
        }
    }
}

extension Localization.ConnectionStatus: Localizable {
    var localizedName: String {
        switch self {
        case .on:
            NSLocalizedString(
                "ConnectionStatus/On.Name",
                value: "Dial",
                comment: "if (connected)"
            )
        case .off:
            NSLocalizedString(
                "ConnectionStatus/Off.Name",
                value: "Dial",
                comment: "if (!connected)"
            )
        case .offBadge:
            NSLocalizedString(
                "ConnectionStatus/OffBadge.Name",
                value: "disconnected",
                comment: "if (!connected) badge"
            )
        case .offPlaceholder:
            NSLocalizedString(
                "ConnectionStatus/OffPlaceholder.Name",
                value: "Surface Dial disconnected",
                comment: "if (!connected) badge"
            )
        }
    }
}

extension Localization.General: Localizable {
    var localizedName: String {
        switch self {
        case .sensitivity:
            NSLocalizedString("General/Sensitivity.Name", value: "Sensitivity", comment: "sensitivity")
        case .direction:
            NSLocalizedString("General/Direction.Name", value: "Primary direction", comment: "direction")
        case .haptics:
            NSLocalizedString("General/Haptics.Name", value: "Global haptic feedback", comment: "haptics")
        case .autoHidesIcon:
            NSLocalizedString("General/AutoHidesIcon.Name", value: "Hides icon while disconnected", comment: "auto hides icon")
        case .startsWithMacOS:
            NSLocalizedString("General/StartsWithMacOS.Name", value: "Starts with macOS", comment: "starts with macOS")
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .sensitivity:
            NSLocalizedString("General/Sensitivity.Title", value: "Sensitivity", comment: "sensitivity")
        case .direction:
            NSLocalizedString("General/Direction.Title", value: "Primary Direction", comment: "direction")
        case .haptics:
            NSLocalizedString("General/Haptics.Title", value: "Global Haptic Feedback", comment: "haptics")
        case .autoHidesIcon:
            NSLocalizedString("General/AutoHideIcon.Title", value: "Hides Icon while Disconnected", comment: "auto hides icon")
        case .startsWithMacOS:
            NSLocalizedString("General/StartsWithMacOS.Title", value: "Starts with macOS", comment: "starts with macOS")
        }
    }
}

extension Localization.Controllers.Shortcuts: Localizable {
    var localizedName: String {
        switch self {
        case .idle:
            NSLocalizedString("Controllers/Shortcuts/Idle.Name", value: "Press and enter", comment: "idle")
        case .cancellable:
            NSLocalizedString("Controllers/Shortcuts/Cancellable.Name", value: "Release to cancel", comment: "cancellable")
        }
    }
}

extension Localization.Controllers.Advanced: Localizable {
    var localizedName: String {
        switch self {
        case .rotationType:
            NSLocalizedString("Controllers/Advanced/RotationType.Name", value: "Rotation type", comment: "rotation type")
        case .haptics:
            NSLocalizedString("Controllers/Advanced/Haptics.Name", value: "Haptic feedback", comment: "haptics")
        case .physicalDirection:
            NSLocalizedString("Controllers/Advanced/PhysicalDirection.Name", value: "Follows physical direction", comment: "physical direction")
        case .alternativeDirection:
            NSLocalizedString("Controllers/Advanced/AlternativeDirection.Name", value: "Alternative direction", comment: "alternative direction")
        }
    }
}

