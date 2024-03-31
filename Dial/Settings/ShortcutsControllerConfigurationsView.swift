//
//  ShortcutsControllerConfigurationsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI
import SFSafeSymbols

struct ShortcutsControllerConfigurationsView: View {
    @Binding var id: ControllerID
    
    @StateObject private var keyboardRecorderModel: KeyboardRecorderModel = .init()
    
    @State var isSectionExpanded: Bool = true
    
    @ViewBuilder
    func buildShortcutsStackView(
        _ keybind: Binding<ShortcutArray>,
        symbol: SFSymbol,
        label: () -> some View
    ) -> some View {
        HStack {
            Image(systemSymbol: symbol)
            label()
            
            Spacer()
            
            KeyboardRecorderView(keybind)
        }
    }
    
    var body: some View {
        Form {
            let controller = Binding(get: {
                id.controller as! ShortcutsController
            }, set: { newValue in
                id.controller = newValue
            })
            
            // MARK: - Shortcuts
            
            Section("Triggers when…", isExpanded: $isSectionExpanded) {
                Section {
                    buildShortcutsStackView(
                        controller.shortcuts.rotate.clockwisely,
                        symbol: .digitalcrownHorizontalArrowClockwise
                    ) {
                        Text("Rotate clockwisely")
                    }
                    
                    buildShortcutsStackView(
                        controller.shortcuts.rotate.counterclockwisely,
                        symbol: .digitalcrownHorizontalArrowCounterclockwise
                    ) {
                        Text("Rotate counterclockwisely")
                    }
                }
                
                Section {
                    buildShortcutsStackView(
                        controller.shortcuts.press,
                        symbol: .digitalcrownHorizontalPress
                    ) {
                        Text("Press")
                    }
                    
                    buildShortcutsStackView(
                        controller.shortcuts.doublePress,
                        symbol: .digitalcrownHorizontalPressFill
                    ) {
                        Text("Double press")
                    }
                }
                
                Section {
                    buildShortcutsStackView(
                        controller.shortcuts.pressAndRotate.clockwisely,
                        symbol: .digitalcrownHorizontalArrowClockwiseFill
                    ) {
                        Text("Press and rotate clockwisely")
                    }
                    
                    buildShortcutsStackView(
                        controller.shortcuts.pressAndRotate.counterclockwisely,
                        symbol: .digitalcrownHorizontalArrowCounterclockwiseFill
                    ) {
                        Text("Press and rotate counterclockwisely")
                    }
                }
            }
            
            // MARK: - Configurations
            
            Section("Configurations") {
                Toggle("Haptic feedback", isOn: controller.haptics)
            }
            
            Section {
                Toggle("Follows physical direction", isOn: controller.physicalDirection)
                
                Toggle(isOn: controller.alternativeDirection) {
                    Text("Alternates direction")
                    
                    Text("This option applies after \"Follows physical direction\".")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
            }
            
            Section {
                Picker("Rotation type", selection: controller.rotationType) {
                    ForEach(Rotation.RawType.allCases) { rotationType in
                        Text(rotationType.name)
                            .badge(Text(rotationType.symbol.unicode!))
                    }
                }
                .badge(Text(controller.wrappedValue.rotationType.symbol.image))
            }
        }
        .environmentObject(keyboardRecorderModel)
        .formStyle(.grouped)
        .controlSize(.regular)
        .animation(.easeInOut, value: isSectionExpanded)
    }
}

#Preview {
    struct ControllerConfigurationsWrapper: View {
        var body: some View {
            ShortcutsControllerConfigurationsView(id: .constant(.shortcuts(.init())))
        }
    }
    
    return ControllerConfigurationsWrapper()
}
