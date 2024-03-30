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
        case .low:
            60
        case .medium:
            90
        case .natural:
            120
        case .high:
            240
        case .extreme:
            360
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
            String(localized: .init("Sensitivity: Low Name", defaultValue: "Low"))
        case .medium:
            String(localized: .init("Sensitivity: Medium Name", defaultValue: "Medium"))
        case .natural:
            String(localized: .init("Sensitivity: Natural Name", defaultValue: "Natural"))
        case .high:
            String(localized: .init("Sensitivity: High Name", defaultValue: "High"))
        case .extreme:
            String(localized: .init("Sensitivity: Extreme Name", defaultValue: "Extreme"))
        }
    }
}

extension Sensitivity: SymbolRepresentable {
    var symbol: SFSafeSymbols.SFSymbol {
        switch self {
        case .low:
                .hexagon
        case .medium:
                .rays
        case .natural:
                .slowmo
        case .high:
                .timelapse
        case .extreme:
                .circleCircle
        }
    }
}

enum Direction: Int, CaseIterable, Codable, Defaults.Serializable {
    case clockwise = 1
    
    case counterclockwise = -1
    
    var negate: Direction {
        switch self {
        case .clockwise:
                .counterclockwise
        case .counterclockwise:
                .clockwise
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
        case .clockwise:
            self
        case .counterclockwise:
            self.negate
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
            String(localized: .init("Direction: Clockwise Name", defaultValue: "Clockwise"))
        case .counterclockwise:
            String(localized: .init("Direction: Counterclockwise Name", defaultValue: "Counterclockwise"))
        }
    }
}

extension Direction: SymbolRepresentable {
    var symbol: SFSymbol {
        switch self {
        case .clockwise:
                .digitalcrownHorizontalArrowClockwiseFill
        case .counterclockwise:
                .digitalcrownHorizontalArrowCounterclockwiseFill
        }
    }
}

enum Rotation: Codable {
    case continuous(Direction)
    
    case stepping(Direction)
    
    var type: RawType {
        switch self {
        case .continuous(_):
                .continuous
        case .stepping(_):
                .stepping
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
            case .continuous:
                true
            case .stepping:
                false
            }
        }
    }
}

extension Rotation.RawType: Localizable {
    var name: String {
        switch self {
        case .continuous:
            String(localized: .init("Rotation: Continuous Name", defaultValue: "Continuous"))
        case .stepping:
            String(localized: .init("Rotation: Stepping Name", defaultValue: "Stepping"))
        }
    }
}

extension Rotation.RawType: SymbolRepresentable {
    var symbol: SFSymbol {
        switch self {
        case .continuous:
            .alternatingcurrent
        case .stepping:
            .directcurrent
        }
    }
}

extension Rotation.RawType: Identifiable {
    var id: Self {
        self
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
