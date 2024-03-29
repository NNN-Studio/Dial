//
//  ControllersSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct ControllersSettingsView: View {
    // Do not use `@Default()` as it results in data inconsistencies and index out of range errors.
    @State var activated: [ControllerID] = []
    @State var nonactivated: [ControllerID] = []
    @State var selected: ControllerID?
    
    @State var searchText: String = ""
    
    func filter(_ data: Binding<[ControllerID]>) -> Array<Binding<ControllerID>> {
        data.filter {
            searchText.isEmpty || ($0.wrappedValue.controller.name ?? "").localizedStandardContains(searchText)
        }
    }
    
    @ViewBuilder
    func buildNavigationLinkView(id: Binding<ControllerID>) -> some View {
        NavigationLink {
            Text(id.wrappedValue.controller.name ?? newControllerName)
        } label: {
            ControllerStateEntryView(id: id)
        }
        //.draggable(id.wrappedValue)
    }
    
    @ViewBuilder
    func buildListView() -> some View {
        List(selection: $selected) {
            Section("Activated") {
                ForEach(filter($activated)) { id in
                    buildNavigationLinkView(id: id)
                }
                .onMove { indices, destination in
                    activated.move(fromOffsets: indices, toOffset: destination)
                }
            }
            
            Section("Nonactivated") {
                ForEach(filter($nonactivated)) { id in
                    buildNavigationLinkView(id: id)
                }
                .onMove { indices, destination in
                    nonactivated.move(fromOffsets: indices, toOffset: destination)
                }
            }
        }
    }
    
    @ViewBuilder
    func buildFooterView() -> some View {
        HStack {
            Text("\($activated.count + $nonactivated.count) controllers, \($activated.count) activated")
                .font(.footnote)
                .foregroundStyle(.placeholder)
            
            Spacer()
            
            Button {
                guard let selected else { return }
                Defaults.removeController(id: selected)
                
                self.selected = nil
            } label: {
                Image(systemSymbol: .minus)
            }
            .disabled(selected == nil)
            
            Menu {
                Menu {
                    ForEach(ControllerID.Builtin.availableCases) { id in
                        Button {
                            Defaults.appendBuiltinController(id: id)
                        } label: {
                            Text(id.controller.name ?? newControllerName)
                            Image(systemSymbol: id.controller.symbol)
                        }
                        .disabled(activated.contains(id.linkage))
                    }
                } label: {
                    Text("Builtin")
                    Image(systemSymbol: .ellipsisCurlybraces)
                }
                
                Button {
                    Defaults.appendNewController()
                } label: {
                    Text(newControllerName)
                    Image(systemSymbol: .gearBadge)
                }
            } label: {
                Image(systemSymbol: .plus)
            }
        }
        .buttonStyle(.borderless)
    }
    
    var body: some View {
        NavigationSplitView {
            Group {
                buildListView()
                    .animation(.easeInOut, value: activated)
                    .animation(.easeInOut, value: nonactivated)
                    .padding(.all, 0)
                    .padding(.bottom, 30)
                    .overlay(alignment: .bottom) {
                        VStack {
                            Divider()
                            
                            buildFooterView()
                                .padding(.horizontal)
                                .padding(.top, 2)
                                .padding(.bottom, 6)
                        }
                    }
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        } detail: {
            Group {
                StaleView()
                    .frame(width: 64)
            }
            .navigationSplitViewColumnWidth(min: 400, ideal: 400)
        }
        .controlSize(.extraLarge)
        .searchable(text: $searchText, placement: .sidebar)
        .task {
            // MARK: Update activated controller ids
            
            for await activatedControllerIDs in Defaults.updates(.activatedControllerIDs) {
                // Clear the list to force refresh it, important!
                self.activated = []
                self.activated = activatedControllerIDs
            }
        }
        .task {
            // MARK: Update nonactivated controller ids
            
            for await nonactivatedControllerIDs in Defaults.updates(.nonactivatedControllerIDs) {
                // Clear the list to force refresh it, important!
                self.nonactivated = []
                self.nonactivated = nonactivatedControllerIDs
            }
        }
    }
}

#Preview("Settings") {
    ControllersSettingsView()
}

struct ControllerStateEntryView: View {
    @Binding var id: ControllerID
    
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemSymbol: id.controller.symbol)
                .imageScale(.large)
                .frame(width: 32)
            
            VStack(alignment: .leading) {
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
                Button {
                    isTextFieldFocused = true
                } label: {
                    Text("Rename")
                }
                .disabled(id.isBuiltin)
            }
            
            Divider()
            
            if !id.isBuiltin {
                Button {
                    switch id {
                    case .shortcuts(let settings):
                        id = .shortcuts(settings.new(resetsName: true, resetsSymbol: true))
                    case .builtin(_):
                        break
                    }
                } label: {
                    Text("Reset")
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

#Preview("Entries") {
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
