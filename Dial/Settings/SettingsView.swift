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
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tag(0)
                .tabItem {
                    Image(systemSymbol: .gear)
                    Text("General")
                }
                .frame(width: 450)
                .frame(minHeight: 600)
            
            ControllersSettingsView()
                .tag(1)
                .tabItem {
                    Image(systemSymbol: .hockeyPuck)
                    Text("Controllers")
                }
                .frame(width: 450)
            
            DialMenuSettingsView()
                .tag(2)
                .tabItem {
                    Image(systemSymbol: .circleCircle)
                    Text("Dial Menu")
                }
                .frame(width: 450)
            
            AboutView()
                .tag(3)
                .tabItem {
                    Image(systemSymbol: .ellipsis)
                    Text("About")
                }
                .frame(width: 450)
        }
        .task {
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