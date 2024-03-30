//
//  ControllerConfigurationsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI

struct ControllerConfigurationsView: View {
    @Binding var id: ControllerID
    
    @StateObject private var keyboardRecorderModel: KeyboardRecorderModel = .init()
    
    var body: some View {
        Form {
            let controller = Binding(get: {
                id.controller as! ShortcutsController
            }, set: { newValue in
                id.controller = newValue
            })
            
            // MARK: - Shortcuts
            
            Section("Shortcuts") {
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalArrowClockwise)
                        Text("Rotate clockwisely")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        KeyboardRecorderView(controller.shortcuts.rotation.clockwise)
                    }
                }
                
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwise)
                        Text("Rotate counterclockwisely")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Test")
                    }
                }
            }
            
            Section() {
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalPress)
                        Text("Press")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Test")
                    }
                }
                
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalPressFill)
                        Text("Double press")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Test")
                    }
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalArrowClockwiseFill)
                        Text("Press and rotate clockwisely")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Test")
                    }
                }
                
                VStack {
                    HStack {
                        Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwiseFill)
                        Text("Press and rotate counterclockwisely")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("Test")
                    }
                }
            }
            
            // MARK: - Configurations
            
            Section("Configurations") {
                Toggle("Haptics", isOn: controller.haptics)
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
                    }
                }
                .badge(Text(controller.wrappedValue.rotationType.symbol.unicode!))
            }
        }
        .controlSize(.regular)
        .formStyle(.grouped)
        .environmentObject(keyboardRecorderModel)
    }
}

#Preview {
    struct ControllerConfigurationsWrapper: View {
        var body: some View {
            ControllerConfigurationsView(id: .constant(.shortcuts(.init())))
        }
    }
    
    return ControllerConfigurationsWrapper()
}
