//
//  ControllerEntryView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI
import Defaults

struct ControllerStateEntryView: View {
    @Binding var id: ControllerID
    
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            ControllerIconView(id: $id)
                .imageScale(.large)
                .frame(width: 32)
            
            VStack(alignment: .leading) {
                // This crashes previews. Why?
                TextField(newControllerName, text: $id.controller.nameOrEmpty)
                    .focused($isTextFieldFocused)
                    .orSomeView(condition: id.isBuiltin) {
                        // Immutable names with builtin controllers
                        Text(id.controller.name ?? newControllerName)
                    }
                    .font(.title3)
                
                switch id {
                case .shortcuts(let settings):
                    Text(settings.id.uuidString)
                        .font(.monospaced(.caption)())
                        .foregroundStyle(.placeholder)
                        .help(settings.id.uuidString)
                case .builtin(_):
                    Text("Default Controller")
                        .font(.monospaced(.caption)())
                        .foregroundStyle(.placeholder)
                }
            }
            .lineLimit(1)
            
            Spacer()
            
            Toggle(isOn: $id.isActivated) {
            }
            .toggleStyle(.checkbox)
            .help("Controller activated")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .contextMenu(ContextMenu(menuItems: {
            if !id.isBuiltin {
                Button("Rename") {
                    isTextFieldFocused = true
                }
                .disabled(id.isBuiltin)
            }
            
            Divider()
            
            if !id.isBuiltin {
                Button("Reset") {
                    switch id {
                    case .shortcuts(let settings):
                        (id.controller as? ShortcutsController)?.settings = settings.new()
                    case .builtin(_):
                        break
                    }
                }
                .disabled(id.isBuiltin)
            }
            
            Button(role: .destructive) {
                Defaults.removeController(id: id)
            } label: {
                Text("Remove")
                    .foregroundStyle(.red)
            }
        }))
    }
}

#Preview {
    List {
        let settings = ShortcutsController.Settings()
        let controllerID1 = ControllerID.builtin(.scroll)
        let controllerID2 = ControllerID.shortcuts(settings)
        
        ControllerStateEntryView(id: .constant(controllerID1))
        
        ControllerStateEntryView(id: .constant(controllerID2))
    }
    .listStyle(.sidebar)
    .frame(width: 250)
}
