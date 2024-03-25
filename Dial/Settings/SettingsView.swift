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
            
            DummyView() // This is actually unreachable
                .tag(Tab.controllers)
                .tabItem {
                    Image(systemSymbol: .hockeyPuck)
                    Text("Controllers")
                }
            
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
                    Text("More…")
                }
                .frame(width: 450)
                .fixedSize()
        }
        .orSomeView(condition: selectedTab == .controllers) {
            // Special case for the controllers view's `NavigationSplitView` (which is `TabView`-incompatible)
            ControllersSettingsView()
                .frame(height: 650)
                .fixedSize(horizontal: false, vertical: true)
                .toolbar {
                    // Back button
                    Button {
                        selectedTab = restorableTab
                    } label: {
                        Image(systemSymbol: .chevronLeft)
                        
                        Text("Other Settings…")
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
