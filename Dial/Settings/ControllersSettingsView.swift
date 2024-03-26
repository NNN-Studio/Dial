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
    
    @State var isDragging: Bool = false
    
    var body: some View {
        NavigationSplitView {
            Group {
                List(selection: $selectedControllerID) {
                    Section("Activated") {
                        ForEach($activatedControllerIDs) { id in
                            NavigationLink {
                                Text(id.wrappedValue.controller.name)
                            } label: {
                                ControllerStateEntryView(id: id)
                            }
                            .draggable(id.wrappedValue)
                            .onDrop(of: [.controllerID], delegate: ControllerIDDropDelegate(
                                data: $activatedControllerIDs,
                                selected: $selectedControllerID,
                                isDragging: $isDragging,
                                id: id.wrappedValue
                            ))
                        }
                    }
                    
                    Section("Nonactivated") {
                        ForEach($nonactivatedControllerIDs) { id in
                            NavigationLink {
                                Text(id.wrappedValue.controller.name)
                            } label: {
                                ControllerStateEntryView(id: id)
                            }
                            .draggable(id.wrappedValue)
                        }
                    }
                }
            }
            .controlSize(.regular)
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        } detail: {
            Group {
                StaleView()
                    .frame(width: 64)
            }
            .navigationSplitViewColumnWidth(min: 400, ideal: 400)
        }
        .controlSize(.extraLarge)
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

struct ControllerIDDropDelegate: DropDelegate {
    @Binding var data: [ControllerID]
    @Binding var selected: ControllerID?
    @Binding var isDragging: Bool
    
    let id: ControllerID
    
    /// Drop finished work
    func performDrop(info: DropInfo) -> Bool {
        selected = nil
        isDragging = false
        return true
    }
    
    /// Moving style without "+" icon
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    /// Object is dragged off of the `onDrop` view
    func dropExited(info: DropInfo) {
        isDragging = false
    }
    
    /// Object is dragged over the `onDrop` view
    func dropEntered(info: DropInfo) {
        isDragging = true
        guard
            let selected, selected != id,
            let from = data.firstIndex(of: selected),
            let to = data.firstIndex(of: id)
        else { return }
        
        data.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
    }
}

struct ControllerStateEntryView: View {
    @Binding var id: ControllerID
    
    var body: some View {
        HStack {
            Image(systemSymbol: id.controller.symbol)
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
