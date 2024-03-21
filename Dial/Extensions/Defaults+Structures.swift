//
//  Defaults+Structures.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import Defaults
import SFSafeSymbols

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

extension Sensitivity: Localizable {
    var localizedName: String {
        switch self {
        case .low:
            NSLocalizedString("Sensitivity/Low.Name", value: "Low", comment: "low sensitivity")
        case .medium:
            NSLocalizedString("Sensitivity/Medium.Name", value: "Medium", comment: "medium sensitivity")
        case .natural:
            NSLocalizedString("Sensitivity/Natural.Name", value: "Natural", comment: "natural sensitivity")
        case .high:
            NSLocalizedString("Sensitivity/High.Name", value: "High", comment: "high sensitivity")
        case .extreme:
            NSLocalizedString("Sensitivity/Extreme.Name", value: "Extreme", comment: "extreme sensitivity")
        }
    }
    
    var localizedBadge: String {
        switch self {
        case .low:
            NSLocalizedString("Sensitivity/Low.Badge", value: "low", comment: "low sensitivity")
        case .medium:
            NSLocalizedString("Sensitivity/Medium.Badge", value: "medium", comment: "medium sensitivity")
        case .natural:
            NSLocalizedString("Sensitivity/Natural.Badge", value: "natural", comment: "natural sensitivity")
        case .high:
            NSLocalizedString("Sensitivity/High.Badge", value: "high", comment: "high sensitivity")
        case .extreme:
            NSLocalizedString("Sensitivity/Extreme.Badge", value: "extreme", comment: "extreme sensitivity")
        }
    }
}

extension Sensitivity: SymbolRepresentable {
    var representingSymbol: SFSafeSymbols.SFSymbol {
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
        self.multiply(Defaults[.direction])
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

extension Direction: Localizable {
    var localizedName: String {
        switch self {
        case .clockwise:
            NSLocalizedString("Direction/Clockwise.Name", value: "Clockwise", comment: "clockwise direction")
        case .counterclockwise:
            NSLocalizedString("Direction/Counterclockwise.Name", value: "Counterclockwise", comment: "counterclockwise direction")
        }
    }
    
    var localizedBadge: String {
        switch self {
        case .clockwise:
            NSLocalizedString("Direction/Clockwise.Badge", value: "clockwise", comment: "clockwise direction")
        case .counterclockwise:
            NSLocalizedString("Direction/Counterclockwise.Badge", value: "counterclockwise", comment: "counterclockwise direction")
        }
    }
}

extension Direction: SymbolRepresentable {
    var representingSymbol: SFSymbol {
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
    
    enum RawType: Codable {
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
    var localizedName: String {
        switch self {
        case .continuous:
            NSLocalizedString("Dial/Rotation/Type/Continuous.Name", value: "Continuous", comment: "continuous rotation type")
        case .stepping:
            NSLocalizedString("Dial/Rotation/Type/Stepping.Name", value: "Stepping", comment: "stepping rotation type")
        }
    }
    
    var localizedBadge: String {
        switch self {
        case .continuous:
            NSLocalizedString("Dial/Rotation/Type/Continuous.Badge", value: "continuous", comment: "continuous rotation type")
        case .stepping:
            NSLocalizedString("Dial/Rotation/Type/Stepping.Badge", value: "stepping", comment: "stepping rotation type")
        }
    }
}

extension Rotation.RawType: SymbolRepresentable {
    var representingSymbol: SFSymbol {
        switch self {
        case .continuous:
                .alternatingcurrent
        case .stepping:
                .directcurrent
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
