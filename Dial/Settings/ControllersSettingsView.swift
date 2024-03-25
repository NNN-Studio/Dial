//
//  ControllersSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct ControllersSettingsView: View {
    // Don't use `@Default()` as it results in data inconsistencies.
    @State var activatedControllerIDs: [ControllerID] = []
    @State var nonactivatedControllerIDs: [ControllerID] = []
    
    @State var selectedControllerID: ControllerID?
    
    var body: some View {
        NavigationSplitView {
            Group {
                NavigationLink {
                    Text("Content 1")
                } label: {
                    Text("Navigation 1")
                }
                
                NavigationLink {
                    Text("Content 2")
                } label: {
                    Text("Navigation 2")
                }
                
                NavigationLink {
                    Text("Content 3")
                } label: {
                    Text("Navigation 3")
                }
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        } detail: {
            Group {
                StaleView()
                    .frame(width: 64)
            }
            .navigationSplitViewColumnWidth(min: 350, ideal: 400)
        }
        .task {
            // MARK: Update activated controller ids
            
            for await activatedControllerIDs in Defaults.updates(.activatedControllerIDs) {
                self.activatedControllerIDs = activatedControllerIDs
            }
        }
        .task {
            // MARK: Update nonactivated controller ids
            
            for await nonactivatedControllerIDs in Defaults.updates(.nonactivatedControllerIDs) {
                self.nonactivatedControllerIDs = nonactivatedControllerIDs
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
            .lineLimit(1)
            
            Spacer()
            
            Toggle(isOn: $id.isActivated) {
            }
            .toggleStyle(.checkbox)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

#Preview {
    Group {
        ControllerStateEntryView(id: .constant(.builtin(.scroll)))
        
        let settings = ShortcutsController.Settings()
        ControllerStateEntryView(id: .constant(.shortcuts(settings)))
    }
    .frame(width: 250)
}
