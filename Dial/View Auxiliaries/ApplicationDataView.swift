//
//  ApplicationDataView.swift
//  Dial
//
//  Created by KrLite on 2024/3/25.
//

import SwiftUI
import Defaults

struct ApplicationDataView: View {
    @State var isShowingRestoreGlobalConfigurationsDialog: Bool = false
    @State var isShowingRestoreControllersDataDialog: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Global Configurations")
                
                Spacer()
                
                // Import
                
                Button {
                    
                } label: {
                    Image(systemSymbol: .trayAndArrowDown)
                        .frame(width: 20)
                }
                
                // Export
                
                ShareLink(item: "Test") {
                    Image(systemSymbol: .squareAndArrowUp)
                        .frame(width: 20)
                }
                
                Divider()
                
                // Reset
                
                Button("Reset") {
                    isShowingRestoreGlobalConfigurationsDialog = true
                }
                .confirmationDialog(
                    "Are You Sure to Reset All Global Configurations?",
                    isPresented: $isShowingRestoreGlobalConfigurationsDialog,
                    titleVisibility: .visible
                ) {
                    Button("Reset", role: .destructive) {
                        resetGlobalConfigurations()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            HStack {
                Text("Controllers Data")
                
                Spacer()
                
                // Import
                
                Button {
                    
                } label: {
                    Image(systemSymbol: .trayAndArrowDown)
                        .frame(width: 20)
                }
                
                // Export
                
                ShareLink(item: "Test") {
                    Image(systemSymbol: .squareAndArrowUp)
                        .frame(width: 20)
                }
                
                Divider()
                
                // Reset
                
                Button("Reset", role: .destructive) {
                    isShowingRestoreControllersDataDialog = true
                }
                .confirmationDialog(
                    "Are You Sure to Reset All Controllers Data?",
                    isPresented: $isShowingRestoreControllersDataDialog,
                    titleVisibility: .visible
                ) {
                    Button("Reset", role: .destructive) {
                        resetControllersData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        .controlSize(.extraLarge)
    }
    
    func resetGlobalConfigurations() {
        Defaults.reset(
            .globalHapticsEnabled,
            .menuBarItemEnabled,
            .menuBarItemAutoHidden,
            .globalSensitivity,
            .globalDirection
        )
        
        print("!!! Reset all global configurations !!!")
    }
    
    func resetControllersData() {
        Defaults.reset(
            .activatedControllerIDs,
            .inactivatedControllerIDs,
            .currentControllerID
        )
        
        print("!!! Reset all controllers data !!!")
    }
}

#Preview {
    Form {
        ApplicationDataView()
    }
    .formStyle(.grouped)
}
