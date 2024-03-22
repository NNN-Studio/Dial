//
//  ShortcutsController.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import Defaults
import SFSafeSymbols
import AppKit

class ShortcutsController: Controller {
    enum ActionTarget: CaseIterable, Codable, Defaults.Serializable {
        case rotateClockwise
        case rotateCounterclockwise
        
        case pressedRotateClockwise
        case pressedRotateCounterclockwise
        
        case clickSingle
        case clickDouble
    }
    
    struct Settings: SymbolRepresentable, Codable, Defaults.Serializable {
        var id: UUID
        var name: String?
        var representingSymbol: SFSymbol
        
        var haptics: Bool
        var physicalDirection: Bool
        var alternativeDirection: Bool
        
        var rotationType: Rotation.RawType
        var shortcuts: Shortcuts
        
        struct Shortcuts: Codable, Defaults.Serializable {
            var rotation: [Direction: ShortcutArray]
            var pressedRotation: [Direction: ShortcutArray]
            
            var single: ShortcutArray
            var double: ShortcutArray
            
            var isEmpty: Bool {
                rotation.values.allSatisfy { $0.isEmpty } && pressedRotation.values.allSatisfy { $0.isEmpty } && single.isEmpty && double.isEmpty
            }
            
            init(
                rotation: [Direction : ShortcutArray] = [
                    .clockwise: .init(),
                    .counterclockwise: .init()
                ],
                pressedRotation: [Direction : ShortcutArray] = [
                    .clockwise: .init(),
                    .counterclockwise: .init()
                ],
                single: ShortcutArray = ShortcutArray(),
                double: ShortcutArray = ShortcutArray()
            ) {
                self.rotation = rotation
                self.pressedRotation = pressedRotation
                self.single = single
                self.double = double
            }
            
            func getModifiers(_ actionTarget: ActionTarget) -> NSEvent.ModifierFlags {
                switch actionTarget {
                case .rotateClockwise:
                    rotation[.clockwise]?.modifiers ?? []
                case .rotateCounterclockwise:
                    rotation[.counterclockwise]?.modifiers ?? []
                    
                case .pressedRotateClockwise:
                    pressedRotation[.clockwise]?.modifiers ?? []
                case .pressedRotateCounterclockwise:
                    pressedRotation[.counterclockwise]?.modifiers ?? []
                    
                case .clickSingle:
                    single.modifiers
                case .clickDouble:
                    double.modifiers
                }
            }
            
            mutating func setModifiers(
                _ actionTarget: ActionTarget,
                modifiers: NSEvent.ModifierFlags,
                activated: Bool
            ) {
                let original = getModifiers(actionTarget)
                let modified = activated ? original.union(modifiers) : original.subtracting(modifiers)
                
                switch actionTarget {
                case .rotateClockwise:
                    rotation[.clockwise]?.modifiers = modified
                case .rotateCounterclockwise:
                    rotation[.counterclockwise]?.modifiers = modified
                    
                case .pressedRotateClockwise:
                    pressedRotation[.clockwise]?.modifiers = modified
                case .pressedRotateCounterclockwise:
                    pressedRotation[.counterclockwise]?.modifiers = modified
                    
                case .clickSingle:
                    single.modifiers = modified
                case .clickDouble:
                    double.modifiers = modified
                }
            }
        }
        
        init(
            name: String? = nil,
            representingSymbol: SFSymbol = .circleFillableFallback,
            haptics: Bool = true,
            physicalDirection: Bool = false, alternativeDirection: Bool = false,
            rotationType: Rotation.RawType = .continuous, shortcuts: Shortcuts = Shortcuts()
        ) {
            self.id = UUID()
            
            self.name = name
            self.representingSymbol = representingSymbol
            
            self.haptics = haptics
            self.physicalDirection = physicalDirection
            self.alternativeDirection = alternativeDirection
            
            self.rotationType = rotationType
            self.shortcuts = shortcuts
        }
        
        mutating func reset(resetsName: Bool = false, resetsIcon: Bool = false) {
            if resetsName {
                name = nil
            }
            
            if resetsIcon {
                representingSymbol = .circleFillableFallback
            }
            
            haptics = true
            physicalDirection = false
            alternativeDirection = false
            rotationType = .continuous
            shortcuts = Shortcuts()
        }
    }
    
    var settings: Settings
    
    var id: ControllerID {
        .shortcuts(settings)
    }
    
    var name: String {
        settings.name ?? Localization.newController.localizedName
    }
    
    var representingSymbol: SFSymbol {
        settings.representingSymbol
    }
    
    var haptics: Bool {
        settings.haptics
    }
    
    var rotationType: Rotation.RawType {
        settings.rotationType
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func onClick(isDoubleClick: Bool, interval: TimeInterval?, _ callback: SurfaceDial.Callback) {
        if isDoubleClick {
            settings.shortcuts.double.post()
        } else {
            settings.shortcuts.single.post()
        }
    }
    
    func onRotation(
        rotation: Rotation, totalDegrees: Int,
        buttonState: Hardware.ButtonState, interval: TimeInterval?, duration: TimeInterval,
        _ callback: SurfaceDial.Callback
    ) {
        guard rotation.conformsTo(rotationType) else { return }
        
        var direction = rotation.direction
        
        if settings.physicalDirection { direction = direction.physical }
        if settings.alternativeDirection { direction = direction.negate }
        
        switch buttonState {
        case .pressed:
            settings.shortcuts.pressedRotation[direction]?.post()
        case .released:
            settings.shortcuts.rotation[direction]?.post()
        }
        
        if haptics && !rotationType.autoTriggers {
            callback.device.buzz()
        }
    }
}

extension ShortcutsController.Settings: Equatable {
    static func == (lhs: ShortcutsController.Settings, rhs: ShortcutsController.Settings) -> Bool {
        lhs.id == rhs.id
    }
}

extension ShortcutsController.Settings: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ShortcutsController: Equatable {
    static func == (lhs: ShortcutsController, rhs: ShortcutsController) -> Bool {
        lhs.id == rhs.id
    }
}

