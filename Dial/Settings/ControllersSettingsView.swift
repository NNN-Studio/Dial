//
//  ControllersSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct ControllersSettingsView: View {
    @State var controllerIDs: [ControllerID] = []
    @State var selectedControllerID: ControllerID?
    
    var body: some View {
        /*
        HSplitView {
            List($controllerIDs, id: \.self, selection: $selectedControllerID) { controllerID in
                
                ControllerStateEntryView(
                    activated: controllerState.isOn,
                    controllerState: controllerState
                )
                .itemProvider {
                    NSItemProvider(object: DraggableControllerState(controllerState.wrappedValue))
                }
                .onDrop(of: [.draggableControllerState], delegate: DraggableControllerStateDelegate(current: controllerState))
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
         */
        EmptyView()
    }
}

#Preview {
    ControllersSettingsView()
}

struct ControllerStateEntryView: View {
    var body: some View {
        /*
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
         */
        EmptyView()
    }
}

#Preview {
    VStack {
        ControllerStateEntryView()
        
        Divider()
        
        let shortcutsController = ShortcutsController(settings: ShortcutsController.Settings())
        
        ControllerStateEntryView()
    }
    .frame(width: 400)
}
