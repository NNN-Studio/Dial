//
//  Input.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import AppKit
import Defaults

enum Input: Int32, CaseIterable, Codable, Defaults.Serializable {
    // MARK: - Aux keys
    
    static let keyVolumeUp: Int32 = NX_KEYTYPE_SOUND_UP
    
    static let keyVolumeDown: Int32 = NX_KEYTYPE_SOUND_DOWN
    
    static let keyBrightnessUp: Int32 = NX_KEYTYPE_BRIGHTNESS_UP
    
    static let keyBrightnessDown: Int32 = NX_KEYTYPE_BRIGHTNESS_DOWN
    
    static let keyPlay: Int32 = NX_KEYTYPE_PLAY
    
    static let keyMute: Int32 = NX_KEYTYPE_MUTE
    
    static let keyContrastUp: Int32 = NX_KEYTYPE_CONTRAST_UP
    
    static let keyContrastDown: Int32 = NX_KEYTYPE_CONTRAST_DOWN
    
    static let keyIlluminationUp: Int32 = NX_KEYTYPE_ILLUMINATION_UP
    
    static let keyIlluminationDown: Int32 = NX_KEYTYPE_ILLUMINATION_DOWN
    
    static let keyIlluminationToggle: Int32 = NX_KEYTYPE_ILLUMINATION_TOGGLE
    
    // MARK: - Keyboard keys
    
    case unknown = -0x1
    
    // MARK: Signs
    
    case keyLeftArrow = 0x7b
    
    case keyRightArrow = 0x7c
    
    case keyDownArrow = 0x7d
    
    case keyUpArrow = 0x7e
    
    case keyReturn = 0x24
    
    case keyTab = 0x30
    
    case keyEscape = 0x35
    
    case keyBackspace = 0x33
    
    /// ~
    case keyTide = 0x32
    
    /// -
    case keyMinus = 0x1b
    
    /// +
    /// =
    case keyEquals = 0x18
    
    /// {
    /// [
    case keyLeftSquareBracket = 0x21
    
    /// }
    /// ]
    case keyRightSquareBracket = 0x1e
    
    /// |
    /// \
    case keyBackslash = 0x2a
    
    /// :
    /// ;
    case keySemicolon = 0x29
    
    /// "
    /// '
    case keyApostrophe = 0x27
    
    /// <
    /// ,
    case keyComma = 0x2b
    
    /// >
    /// .
    case keyPeriod = 0x2f
    
    /// ?
    /// /
    case keySlash = 0x2c
    
    // MARK: Letters
    
    case keyA = 0x0
    
    case keyB = 0xb
    
    case keyC = 0x8
    
    case keyD = 0x2
    
    case keyE = 0xe
    
    case keyF = 0x3
    
    case keyG = 0x5
    
    case keyH = 0x4
    
    case keyI = 0x22
    
    case keyJ = 0x26
    
    case keyK = 0x28
    
    case keyL = 0x25
    
    case keyM = 0x2e
    
    case keyN = 0x2d
    
    case keyO = 0x1f
    
    case keyP = 0x23
    
    case keyQ = 0xc
    
    case keyR = 0xf
    
    case keyS = 0x1
    
    case keyT = 0x11
    
    case keyU = 0x20
    
    case keyV = 0x9
    
    case keyW = 0xd
    
    case keyX = 0x7
    
    case keyY = 0x10
    
    case keyZ = 0x6
    
    // MARK: Numbers
    
    /// 1
    /// !
    case key1 = 0x12
    
    /// 2
    /// @
    case key2 = 0x13
    
    /// 3
    /// #
    case key3 = 0x14
    
    /// 4
    /// $
    case key4 = 0x15
    
    /// 5
    /// %
    case key5 = 0x17
    
    /// 6
    /// ^
    case key6 = 0x16
    
    /// 7
    /// &
    case key7 = 0x1a
    
    /// 8
    /// *
    case key8 = 0x1c
    
    /// 9
    /// (
    case key9 = 0x19
    
    /// 0
    /// )
    case key0 = 0x1d
    
    // MARK: Function keys
    
    case keyF1 = 0x7a
    
    case keyF2 = 0x78
    
    case keyF3 = 0x63
    
    case keyF4 = 0x76
    
    case keyF5 = 0x60
    
    case keyF6 = 0x61
    
    case keyF7 = 0x62
    
    case keyF8 = 0x64
    
    case keyF9 = 0x65
    
    case keyF10 = 0x6d
    
    case keyF11 = 0x67
    
    case keyF12 = 0x6f
    
    /// The name of the key. Should be displayed with font `SF Mono`.
    var name: String {
        switch self {
        case .unknown:
            "􀿪"
            
        case .keyLeftArrow:
            "􀄪"
        case .keyRightArrow:
            "􀄫"
        case .keyDownArrow:
            "􀄩"
        case .keyUpArrow:
            "􀄨"
        case .keyReturn:
            "􀅇"
        case .keyTab:
            "􁂎"
        case .keyEscape:
            "esc"
        case .keyBackspace:
            "􁂈"
        case .keyTide:
            "~"
        case .keyMinus:
            "-"
        case .keyEquals:
            "="
        case .keyLeftSquareBracket:
            "["
        case .keyRightSquareBracket:
            "]"
        case .keyBackslash:
            "\\"
        case .keySemicolon:
            ";"
        case .keyApostrophe:
            "'"
        case .keyComma:
            ","
        case .keyPeriod:
            "."
        case .keySlash:
            "/"
            
        case .keyF1, .keyF2, .keyF3, .keyF4, .keyF5, .keyF6, .keyF7, .keyF8, .keyF9, .keyF10, .keyF11, .keyF12:
            String(describing: self).replacing(/^keyF/, with: "􀥌")
            
        default:
            String(describing: self).replacing(/^key/, with: "")
        }
    }
    
    init?(rawValue: Int32) {
        self = Input.allCases.filter { $0.rawValue >= 0 && $0.rawValue == rawValue }.first ?? .unknown
    }
    
    func conformsTo(_ keyCode: Int32) -> Bool {
        keyCode == rawValue
    }
    
    func post(modifiers: NSEvent.ModifierFlags = []) {
        Input.postKeys([self], modifiers: modifiers)
    }
    
    static func fromKeyCodes(_ keyCodes: [Int32]) -> [Input] {
        var inputs: [Input] = []
        
        for keyCode in keyCodes {
            if let key = Input(rawValue: keyCode), key != .unknown {
                inputs.append(key)
            }
        }
        
        return inputs
    }
}

extension Input {
    static func postMouse(_ button: CGMouseButton, buttonState action: Hardware.ButtonState) {
        let mouseLocation = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        
        let translatedMouseLocation = NSPoint(x: mouseLocation.x, y: screenHeight - mouseLocation.y)
        var mouseType: CGEventType?
        
        switch button {
        case .left:
            mouseType = action == .pressed ? .leftMouseDown : .leftMouseUp
            break
        case .right:
            mouseType = action == .pressed ? .rightMouseDown : .rightMouseUp
            break
        case .center:
            mouseType = action == .pressed ? .otherMouseDown : .otherMouseUp
            break
        @unknown default:
            break
        }
        
        if let mouseType {
            let event = CGEvent(
                mouseEventSource: nil,
                mouseType: mouseType,
                mouseCursorPosition: translatedMouseLocation,
                mouseButton: button
            )
            
            event?.post(tap: .cghidEventTap)
        }
    }
    
    // https://stackoverflow.com/a/55854051
    static func postAuxKeys(_ keys: [Int32], modifiers: NSEvent.ModifierFlags = [], repetition count: Int = 1) {
        func doKey(_ key: Int32, down: Bool) {
            let rawFlags: UInt = (down ? 0xa00 : 0xb00) | modifiers.rawValue;
            let flags = NSEvent.ModifierFlags(rawValue: rawFlags)
            
            let data1 = Int((key << 16) | (down ? 0xa00 : 0xb00))
            
            let ev = NSEvent.otherEvent(
                with: NSEvent.EventType.systemDefined,
                location: NSPoint(x:0,y:0),
                modifierFlags: flags,
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: data1,
                data2: -1
            )
            
            let cev = ev?.cgEvent
            cev?.post(tap: CGEventTapLocation.cghidEventTap)
        }
        
        for key in keys {
            for _ in 0..<count {
                doKey(key, down: true)
                doKey(key, down: false)
            }
        }
    }
    
    static func postKeys(_ keys: Set<Input>, modifiers: NSEvent.ModifierFlags = [], repetition count: Int = 1) {
        func doKey(_ key: Int32, down: Bool) {
            guard let eventSource = CGEventSource(stateID: .hidSystemState) else {
                print("Failed to create event source")
                return
            }
            
            let ev = CGEvent(
                keyboardEventSource: eventSource,
                virtualKey: CGKeyCode(key),
                keyDown: down
            )
            ev?.flags = CGEventFlags(rawValue: UInt64(modifiers.rawValue))
            ev?.post(tap: .cghidEventTap)
        }
        
        for key in keys {
            for _ in 0..<count {
                doKey(key.rawValue, down: true)
                doKey(key.rawValue, down: false)
            }
        }
    }
}

extension Input: Identifiable {
    var id: Int32 {
        rawValue
    }
}

extension Input: Comparable {
    static func < (lhs: Input, rhs: Input) -> Bool {
        lhs.name < rhs.name
    }
}
