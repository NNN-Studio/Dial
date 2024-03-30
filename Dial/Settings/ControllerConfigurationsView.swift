//
//  ControllerConfigurationsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI

struct ControllerConfigurationsView: View {
    @Binding var id: ControllerID
    
    var body: some View {
        Form {
            let controller = Binding(get: {
                id.controller as! ShortcutsController
            }, set: { newValue in
                id.controller = newValue
            })
            
            // MARK: - Shortcuts
            
            Section("Shortcuts") {
                HStack {
                    Image(systemSymbol: .digitalcrownHorizontalArrowClockwise)
                    Text("Rotate clockwisely")
                }
                
                HStack {
                    Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwise)
                    Text("Rotate counterclockwisely")
                }
            }
            
            Section() {
                HStack {
                    Image(systemSymbol: .digitalcrownHorizontalPress)
                    Text("Press")
                }
                
                HStack {
                    Image(systemSymbol: .digitalcrownHorizontalPressFill)
                    Text("Double press")
                }
            }
            
            HStack {
                Image(systemSymbol: .digitalcrownHorizontalArrowClockwiseFill)
                Text("Press and rotate clockwisely")
            }
            
            HStack {
                Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwiseFill)
                Text("Press and rotate counterclockwisely")
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
                //.badge(Text(controller.wrappedValue.rotationType.symbol.unicode!))
            }
        }
        .controlSize(.regular)
        .formStyle(.grouped)
    }
}

#Preview {
    struct ControllerConfigurationsWrapper: View {
        @State var id: ControllerID = .shortcuts(.init())
        
        var body: some View {
            ControllerConfigurationsView(id: $id)
        }
    }
    
    return ControllerConfigurationsWrapper()
}
