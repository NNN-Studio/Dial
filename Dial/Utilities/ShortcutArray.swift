//
//  ShortcutArray.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import Defaults

extension NSEvent.ModifierFlags: Codable {
    // Make it codable
}

struct ShortcutArray: Codable, Defaults.Serializable {
    var modifiers: NSEvent.ModifierFlags
    
    var keys: Set<Input>
    
    var display: String {
        keys.map { $0.name }.joined(separator: " ")
    }
    
    var isEmpty: Bool {
        keys.isEmpty && modifiers.isEmpty
    }
    
    init(
        modifiers: NSEvent.ModifierFlags = [],
        keys: Set<Input> = Set()
    ) {
        self.modifiers = modifiers
        self.keys = keys
    }
    
    func post() {
        Input.postKeys(keys, modifiers: modifiers)
    }
}

extension ShortcutArray: Equatable {
    // Make it equatable
}

extension ShortcutArray {
    var sortedKeys: [Input] {
        keys.sorted(by: >)
    }
}

extension ShortcutArray {
    struct DirectionBased: Codable {
        var clockwise: ShortcutArray
        var counterclockwise: ShortcutArray
        
        var isAllEmpty: Bool {
            clockwise.isEmpty && counterclockwise.isEmpty
        }
        
        func from(_ direction: Direction) -> ShortcutArray {
            switch direction {
            case .clockwise:
                clockwise
            case .counterclockwise:
                counterclockwise
            }
        }
    }
}
