//
//  ControllersSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct ControllersSettingsView: View {
    @Default(.controllerStates) var controllerStates: [ControllerState]
    
    @State var selectedControllerState: ControllerState?
    
    var body: some View {
        HSplitView {
            List($controllerStates, id: \.self, selection: $selectedControllerState) { controllerState in
                let controller = controllerState.id.controller
                
                ControllerStateEntryView(
                    activated: controllerState.isOn,
                    controllerState: controllerState
                )
            }
            .frame(minWidth: 250)
            .listStyle(.sidebar)
            
            HStack {
                Text("Test")
            }
            .orSomeView(condition: selectedControllerState == nil) {
                Image(systemSymbol: .aqiMedium)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: true)
                    .opacity(0.2)
                    .frame(width: 64)
            }
            .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ControllersSettingsView(selectedControllerState: Defaults[.controllerStates][0])
}

struct ControllerStateEntryView: View {
    @Binding var activated: Bool
    @Binding var controllerState: ControllerState
    
    var body: some View {
        let controller = controllerState.id.controller
        
        HStack {
            Image(systemSymbol: controller.representingSymbol)
                .imageScale(.large)
                .frame(width: 32)
            
            VStack(alignment: .leading) {
                Text(controller.name)
                    .font(.title3)
                
                switch controller.id {
                case .shortcuts(let settings):
                    Text(settings.id.uuidString)
                        .font(.monospaced(.caption)())
                        .foregroundStyle(.placeholder)
                case .builtin(_):
                    Text("Default Controller")
                        .font(.monospaced(.caption)())
                        .foregroundStyle(.placeholder)
                }
            }
            
            Spacer()
            
            Toggle(isOn: $activated) {
                EmptyView()
            }
            .toggleStyle(.switch)
            .controlSize(.small)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

#Preview {
    VStack {
        ControllerStateEntryView(
            activated: .constant(true),
            controllerState: .constant(Defaults[.controllerStates][0])
        )
        
        Divider()
        
        let shortcutsController = ShortcutsController(settings: ShortcutsController.Settings())
        
        ControllerStateEntryView(
            activated: .constant(true),
            controllerState: .constant(.init(shortcutsController.id, true))
        )
    }
    .frame(width: 400)
}
