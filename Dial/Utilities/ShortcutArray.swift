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
    
    var keys: [Input]
    
    var display: String {
        keys.map { $0.name }.joined(separator: " ")
    }
    
    var isEmpty: Bool {
        keys.isEmpty && modifiers.isEmpty
    }
    
    init(
        modifiers: NSEvent.ModifierFlags = [],
        keys: [Input] = []
    ) {
        self.modifiers = modifiers
        self.keys = keys
    }
    
    func post() {
        Input.postKeys(keys, modifiers: modifiers)
    }
}

