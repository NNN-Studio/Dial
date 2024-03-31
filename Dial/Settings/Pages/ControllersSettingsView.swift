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
    @State var inactivated: [ControllerID] = []
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
            ShortcutsControllerDetailsView(id: id)
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
                .onDelete { indexSet in
                    activated.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, destination in
                    activated.move(fromOffsets: indexSet, toOffset: destination)
                    selected = nil
                }
            }
            
            Section("Inactivated") {
                ForEach(filter($inactivated)) { id in
                    buildNavigationLinkView(id: id)
                }
                .onDelete { indexSet in
                    activated.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, destination in
                    inactivated.move(fromOffsets: indexSet, toOffset: destination)
                    selected = nil
                }
            }
        }
    }
    
    @ViewBuilder
    func buildFooterView() -> some View {
        HStack {
            Text("\($activated.count + $inactivated.count) controllers, \($activated.count) activated")
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
                            Text(id.controller.name ?? controllerNamePlaceholder)
                            id.controller.symbol.image
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
                    Text(controllerNamePlaceholder)
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
                    .animation(.easeInOut, value: inactivated)
                    .padding(.all, 0)
                    .padding(.bottom, 32)
                    .overlay(alignment: .bottom) {
                        VStack {
                            Divider()
                            
                            buildFooterView()
                                .padding(.horizontal)
                                .padding(.top, 2)
                                .padding(.bottom, 8)
                        }
                    }
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
        } detail: {
            Group {
                StaleView()
                    .frame(width: 64)
            }
            .navigationSplitViewColumnWidth(min: 450, ideal: 450)
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
            // MARK: Update inactivated controller ids
            
            for await inactivatedControllerIDs in Defaults.updates(.inactivatedControllerIDs) {
                // Clear the list to force refresh it, important!
                self.inactivated = []
                self.inactivated = inactivatedControllerIDs
            }
        }
    }
}

#Preview {
    ControllersSettingsView()
}
