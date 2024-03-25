//
//  SettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import SFSafeSymbols
import TipKit

struct SettingsView: View {
    enum Tab: String, Hashable {
        case general = "general"
        case controllers = "controllers"
        case dialMenu = "dialMenu"
        case more = "more"
    }
    
    @State var selectedTab: Tab = .general
    @State private var restorableTab: Tab = .general
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tag(Tab.general)
                .tabItem {
                    Image(systemSymbol: .gear)
                    Text("General")
                }
                .frame(width: 450)
                .fixedSize()
            
            ControllersSettingsView()
                .tag(Tab.controllers)
                .tabItem {
                    Image(systemSymbol: .hockeyPuck)
                    Text("Controllers")
                }
                .frame(minWidth: 650)
                .frame(height: 500)
            
            DialMenuSettingsView()
                .tag(Tab.dialMenu)
                .tabItem {
                    Image(systemSymbol: .circleCircle)
                    Text("Dial Menu")
                }
                .frame(width: 450)
            
            MoreSettingsView()
                .tag(Tab.more)
                .tabItem {
                    Image(systemSymbol: .ellipsis)
                    Text("More")
                }
                .frame(width: 450)
                .fixedSize()
        }
        .orSomeView(condition: selectedTab == .controllers) {
            // Special case for the `NavigationSplitView` (which is `TabView`-incompatible)
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
            .frame(height: 750)
            .fixedSize(horizontal: false, vertical: true)
            .toolbar {
                // The back button
                Button {
                    selectedTab = restorableTab
                } label: {
                    Image(systemSymbol: .chevronLeft)
                    
                    Text("Other Settings")
                }
                .padding()
            }
            .controlSize(.extraLarge)
        }
        .task {
            // Tips tasks
#if DEBUG
            try? Tips.resetDatastore()
#endif
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            // Remember last tab
            if selectedTab != .controllers {
                restorableTab = selectedTab
            }
        }
    }
}
