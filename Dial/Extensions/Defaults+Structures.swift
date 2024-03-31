//
//  Defaults+Structures.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import Defaults
import SFSafeSymbols
import SwiftUI

/// Decides how much steps per circle the dial is divided into.
enum Sensitivity: CGFloat, CaseIterable, Defaults.Serializable {
    case low = 5
    
    case medium = 7
    
    case natural = 10
    
    case high = 30
    
    case extreme = 45
    
    /// Decides how much steps per circle the dial is divided into in continuous rotation.
    var density: CGFloat {
        switch self {
        case .low: 60
        case .medium: 90
        case .natural: 120
        case .high: 240
        case .extreme: 360
        }
    }
    
    var gap: CGFloat {
        360 / rawValue
    }
    
    var flow: CGFloat {
        360 / density
    }
}

extension Sensitivity: Identifiable {
    var id: Self {
        self
    }
}

extension Sensitivity: Localizable {
    var name: String {
        switch self {
        case .low:
            .init(localized: .init("Sensitivity: Low", defaultValue: "Low"))
        case .medium:
            .init(localized: .init("Sensitivity: Medium", defaultValue: "Medium"))
        case .natural:
            .init(localized: .init("Sensitivity: Natural", defaultValue: "Natural"))
        case .high:
            .init(localized: .init("Sensitivity: High", defaultValue: "High"))
        case .extreme:
            .init(localized: .init("Sensitivity: Extreme", defaultValue: "Extreme"))
        }
    }
}

extension Sensitivity: SymbolRepresentable {
    var symbol: SFSafeSymbols.SFSymbol {
        switch self {
        case .low: .hexagon
        case .medium: .rays
        case .natural: .slowmo
        case .high: .timelapse
        case .extreme: .circleCircle
        }
    }
}

enum Direction: Int, CaseIterable, Codable, Defaults.Serializable {
    case clockwise = 1
    
    case counterclockwise = -1
    
    var negate: Direction {
        switch self {
        case .clockwise: .counterclockwise
        case .counterclockwise: .clockwise
        }
    }
    
    var physical: Direction {
        self.multiply(Defaults[.globalDirection])
    }
    
    func negateIf(_ flag: Bool) -> Direction {
        flag ? negate : self
    }
    
    func multiply(_ another: Direction) -> Direction {
        switch another {
        case .clockwise: self
        case .counterclockwise: self.negate
        }
    }
}

extension Direction: Identifiable {
    var id: Self {
        self
    }
}

extension Direction: Localizable {
    var name: String {
        switch self {
        case .clockwise:
            .init(localized: .init("Direction: Clockwise", defaultValue: "Clockwise"))
        case .counterclockwise:
            .init(localized: .init("Direction: Counterclockwise", defaultValue: "Counterclockwise"))
        }
    }
}

extension Direction: SymbolRepresentable {
    var symbol: SFSymbol {
        switch self {
        case .clockwise: .digitalcrownHorizontalArrowClockwiseFill
        case .counterclockwise: .digitalcrownHorizontalArrowCounterclockwiseFill
        }
    }
}

enum Rotation: Codable {
    case continuous(Direction)
    
    case stepping(Direction)
    
    var type: RawType {
        switch self {
        case .continuous(_): .continuous
        case .stepping(_): .stepping
        }
    }
    
    var direction: Direction {
        switch self {
        case .continuous(let direction), .stepping(let direction):
            direction
        }
    }
    
    var autoTriggers: Bool {
        type.autoTriggers
    }
    
    func conformsTo(_ type: RawType) -> Bool {
        self.type == type
    }
    
    enum RawType: Codable, CaseIterable {
        case continuous
        case stepping
        
        var autoTriggers: Bool {
            switch self {
            case .continuous: true
            case .stepping: false
            }
        }
    }
}

extension Rotation.RawType: Localizable {
    var name: String {
        switch self {
        case .continuous:
            .init(localized: .init("Rotation: Continuous", defaultValue: "Continuous"))
        case .stepping:
            .init(localized: .init("Rotation: Stepping", defaultValue: "Stepping"))
        }
    }
}

extension Rotation.RawType: SymbolRepresentable {
    var symbol: SFSymbol {
        switch self {
        case .continuous: .alternatingcurrent
        case .stepping: .directcurrent
        }
    }
}

extension Rotation.RawType: Identifiable {
    var id: Self {
        self
    }
}

enum DialMenuThickness: CaseIterable, Codable, Defaults.Serializable {
    case thin
    case regular
    case thick
    
    var value: CGFloat {
        switch self {
        case .thin: 24
        case .regular: 32
        case .thick: 50
        }
    }
}

extension DialMenuThickness: SymbolRepresentable {
    var symbol: SFSafeSymbols.SFSymbol {
        switch self {
        case .thin: .eyedropper
        case .regular: .eyedropperHalffull
        case .thick: .eyedropperFull
        }
    }
}

extension DialMenuThickness: Localizable {
    var name: String {
        switch self {
        case .thin:
                .init(localized: .init("Dial Menu Thickness: Thin", defaultValue: "Thin"))
        case .regular:
                .init(localized: .init("Dial Menu Thickness: Regular", defaultValue: "Regular"))
        case .thick:
                .init(localized: .init("Dial Menu Thickness: Thick", defaultValue: "Thick"))
        }
    }
}

enum DialMenuAnimation: CaseIterable, Codable, Defaults.Serializable {
    case none
    case linear
    case smooth
    case bouncy
    case spring
    case snappy
    case easeIn
    case easeOut
    case easeInOut
    case interactiveSpring
    case interpolativeSpring
    
    var value: Animation? {
        switch self {
        case .linear: .linear
        case .smooth: .smooth
        case .bouncy: .bouncy
        case .spring: .spring
        case .snappy: .snappy
        case .easeIn: .easeIn
        case .easeOut: .easeOut
        case .easeInOut: .easeInOut
        case .interactiveSpring: .interactiveSpring
        case .interpolativeSpring: .interpolatingSpring
        default: nil
        }
    }
}

extension DialMenuAnimation: SymbolRepresentable {
    var symbol: SFSafeSymbols.SFSymbol {
        switch self {
        case .none: .crop
        case .linear: .lineDiagonal
        case .smooth: .scribble
        case .bouncy: .linesMeasurementHorizontal
        case .spring: .wandAndStars
        case .snappy: .wandAndRays
        case .easeIn: .textLineFirstAndArrowtriangleForward
        case .easeOut: .textLineLastAndArrowtriangleForward
        case .easeInOut: .arrowUpAndDownTextHorizontal
        case .interactiveSpring: .aqiLow
        case .interpolativeSpring: .aqiMedium
        }
    }
}

extension DialMenuAnimation: Localizable {
    var name: String {
        switch self {
        case .none:
                .init(localized: .init("Dial Menu Animation: None", defaultValue: "None"))
        case .linear:
                .init(localized: .init("Dial Menu Animation: Linear", defaultValue: "Linear"))
        case .smooth:
                .init(localized: .init("Dial Menu Animation: Smooth", defaultValue: "Smooth"))
        case .bouncy:
                .init(localized: .init("Dial Menu Animation: Bouncy", defaultValue: "Bouncy"))
        case .spring:
                .init(localized: .init("Dial Menu Animation: Spring", defaultValue: "Spring"))
        case .snappy:
                .init(localized: .init("Dial Menu Animation: Snappy", defaultValue: "Snappy"))
        case .easeIn:
                .init(localized: .init("Dial Menu Animation: Ease In", defaultValue: "Ease In"))
        case .easeOut:
                .init(localized: .init("Dial Menu Animation: Ease Out", defaultValue: "Ease Out"))
        case .easeInOut:
                .init(localized: .init("Dial Menu Animation: Ease In Out", defaultValue: "Ease In Out"))
        case .interactiveSpring:
                .init(localized: .init("Dial Menu Animation: Interactive Spring", defaultValue: "Interactive Spring"))
        case .interpolativeSpring:
                .init(localized: .init("Dial Menu Animation: Interpolative Spring", defaultValue: "Interpolative Spring"))
        }
    }
}

struct Bag<Element: Defaults.Serializable>: Collection {
    var items: [Element]
    
    var startIndex: Int { items.startIndex }
    var endIndex: Int { items.endIndex }
    
    mutating func insert(element: Element, at: Int) {
        items.insert(element, at: at)
    }
    
    func index(after index: Int) -> Int {
        items.index(after: index)
    }
    
    subscript(position: Int) -> Element {
        items[position]
    }
}

extension Bag: Defaults.CollectionSerializable {
    init(_ elements: [Element]) {
        self.items = elements
    }
}
