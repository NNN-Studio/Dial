//
//  ModifierFlags+Extensions.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import Foundation
import AppKit
import SFSafeSymbols

extension NSEvent.ModifierFlags: Hashable {
    // Make it hashable
}

extension NSEvent.ModifierFlags: Identifiable {
    public var id: Self {
        self
    }
}

extension NSEvent.ModifierFlags: Comparable {
    public static func < (lhs: NSEvent.ModifierFlags, rhs: NSEvent.ModifierFlags) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension NSEvent.ModifierFlags {
    var keys: Set<NSEvent.ModifierFlags> {
        var result: Set<NSEvent.ModifierFlags> = Set()
        
        if self.contains(.capsLock) {
            result.insert(.capsLock)
        }
        
        if self.contains(.command) {
            result.insert(.command)
        }
        
        if self.contains(.control) {
            result.insert(.control)
        }
        
        if self.contains(.function) {
            result.insert(.function)
        }
        
        if self.contains(.help) {
            result.insert(.help)
        }
        
        if self.contains(.numericPad) {
            result.insert(.numericPad)
        }
        
        if self.contains(.option) {
            result.insert(.option)
        }
        
        if self.contains(.shift) {
            result.insert(.shift)
        }
        
        return result
    }
    
    var sortedKeys: [NSEvent.ModifierFlags] {
        keys.sorted(by: >)
    }
}

extension NSEvent.ModifierFlags: SymbolRepresentable {
    var symbol: SFSafeSymbols.SFSymbol {
        switch self {
        case [.capsLock]: .capslock
        case [.command]: .command
        case [.control]: .control
        case [.function]: .fn
        case [.help]: .questionmark
        case [.numericPad]: .number
        case [.option]: .option
        case [.shift]: .shift
            
        default: .questionmarkAppDashed
        }
    }
}
