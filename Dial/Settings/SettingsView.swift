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
    enum Tab: String, Hashable, CaseIterable {
        case general = "general"
        case controllers = "controllers"
        case dialMenu = "dialMenu"
        case more = "more"
        
        @ViewBuilder
        var tabItemView: some View {
            Group {
                switch self {
                case .general:
                    Image(systemSymbol: .gear)
                    Text("General")
                case .controllers:
                    Image(systemSymbol: .hockeyPuck)
                    Text("Controllers")
                case .dialMenu:
                    Image(systemSymbol: .circleCircle)
                    Text("Dial Menu")
                case .more:
                    Image(systemSymbol: .curlybraces)
                    Text("More…")
                }
            }
        }
    }
    
    @State var selectedTab: Tab = .general
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tag(Tab.general)
                .tabItem {
                    Tab.general.tabItemView
                }
                .frame(width: 450)
                .fixedSize()
            
            DummyView() // This is actually unreachable
                .tag(Tab.controllers)
                .tabItem {
                    Tab.controllers.tabItemView
                }
            
            DialMenuSettingsView()
                .tag(Tab.dialMenu)
                .tabItem {
                    Tab.dialMenu.tabItemView
                }
                .frame(width: 450)
            
            MoreSettingsView()
                .tag(Tab.more)
                .tabItem {
                    Tab.more.tabItemView
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
                    ForEach(Tab.allCases) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            tab.tabItemView
                        }
                        .disabled(tab == selectedTab)
                    }
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
    }
}

extension SettingsView.Tab: Identifiable {
    /// This is intended to make `SettingsView.Tab` conforms to `Identifiable`. The return value is the same as itself.
    var id: Self {
        self
    }
}
