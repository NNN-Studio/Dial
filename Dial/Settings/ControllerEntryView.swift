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
    
    @Default(.currentControllerID) var current
    
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            ZStack {
                if current == id {
                    Circle()
                        .scale(1.25)
                        .fill(.quinary)
                }
                
                ControllerIconView(id: $id)
                    .imageScale(.large)
            }
            .frame(width: 32)
            .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                // This crashes previews. Why?
                TextField(controllerNamePlaceholder, text: $id.controller.nameOrEmpty)
                    .focused($isTextFieldFocused)
                    .orSomeView(condition: id.isBuiltin) {
                        // Immutable names with builtin controllers
                        Text(id.controller.name ?? controllerNamePlaceholder)
                    }
                    .font(.title3)
                
                switch id {
                case .shortcuts(let settings):
                    Text(settings.id.uuidString)
                        .font(.caption)
                        .monospaced()
                        .foregroundStyle(.placeholder)
                        .help(settings.id.uuidString)
                case .builtin(_):
                    Text("Builtin Controller")
                        .font(.caption)
                        .monospaced()
                        .foregroundStyle(.placeholder)
                }
            }
            .lineLimit(1)
            
            Spacer()
            
            Toggle(isOn: $id.isActivated) {
                // No label
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
