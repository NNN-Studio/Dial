//
//  ControllersSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct ControllersSettingsView: View {
    @State var allControllerIDs: [ControllerID] = []
    @State var activatedControllerIDs: [ControllerID] = []
    @State var nonactivatedControllerIDs: [ControllerID] = []
    
    @State var selectedControllerID: ControllerID?
    
    var body: some View {
        HSplitView {
            List($activatedControllerIDs, id: \.self, selection: $selectedControllerID) { id in
                ControllerStateEntryView(id: id)
            }
            .frame(minWidth: 250)
            .listStyle(.sidebar)
            
            HStack {
                Text(selectedControllerID?.controller.name ?? "")
            }
            .orSomeView(condition: selectedControllerID == nil) {
                Image(systemSymbol: .aqiMedium)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: true)
                    .opacity(0.2)
                    .frame(width: 64)
            }
            .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            // Don't use `@Default()` as it results in data inconsistencies.
            
            // MARK: Update activated controller ids
            
            for await ids in Defaults.updates(.activatedControllerIDs) {
                activatedControllerIDs = ids
                allControllerIDs = Defaults.allControllerIDs
            }
            
            // MARK: Update nonactivated controller ids
            
            for await ids in Defaults.updates(.activatedControllerIDs) {
                activatedControllerIDs = ids
                allControllerIDs = Defaults.allControllerIDs
            }
        }
    }
}

#Preview {
    ControllersSettingsView()
}

struct ControllerStateEntryView: View {
    @Binding var id: ControllerID
    
    var body: some View {
        HStack {
            Image(systemSymbol: id.controller.representingSymbol)
                .imageScale(.large)
                .frame(width: 32)
            
            VStack(alignment: .leading) {
                Text(id.controller.name)
                    .font(.title3)
                
                switch id {
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
            
            Toggle(isOn: $id.isActivated) {
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
        ControllerStateEntryView(id: .constant(.builtin(.scroll)))
        
        Divider()
        
        let settings = ShortcutsController.Settings()
        ControllerStateEntryView(id: .constant(.shortcuts(settings)))
    }
    .frame(width: 400)
}
