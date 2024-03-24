//
//  MenuBarMenuView.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI
import SettingsAccess
import Defaults
import LaunchAtLogin

struct MenuBarMenuView: View {
    @State var isConnected: Bool = false
    @State var serial: String? = nil
    @State var controllerStates: [ControllerState] = []
    
    @Default(.currentControllerIndex) var currentControllerIndex
    
    @Default(.globalHapticsEnabled) var globalHapticsEnabled
    @Default(.globalSensitivity) var globalSensitivity
    @Default(.globalDirection) var globalDirection
    
    @ObservedObject var startsWithMacOS = LaunchAtLogin.observable
    
    var body: some View {
        // MARK: - Status
        
        Button {
        } label: {
            Text("Surface Dial")
            Image(systemSymbol: .hockeyPuck)
        }
        .disabled(true)
        .badge(Text(serial ?? ""))
        .orSomeView(condition: !isConnected) {
            Button {
                dial.connect()
            } label: {
                Image(systemSymbol: .arrowTriangle2Circlepath)
                Text("Surface Dial")
            }
            .badge(Text("disconnected"))
        }
        
        Divider()
        
        // MARK: - Controllers
        
        let controllerStatesBinding = Binding {
            controllerStates
        } set: {
            Defaults.activatedControllerStates = $0
        }
        
        Text("Controllers")
            .badge(Text("press and hold dial"))
        
        ForEach(controllerStatesBinding) { state in
            let controller = state.id.controller
            
            Toggle(isOn: state.isOn) {
                Image(systemSymbol: controller.representingSymbol)
                Text(controller.name)
            }
        }
        
        Divider()
        
        // MARK: - Quick Settings
        
        Text("Quick Settings")
        
        Toggle(isOn: $globalHapticsEnabled) {
            Text("Haptics feedback")
        }
        
        Picker(selection: $globalSensitivity) {
            ForEach(Sensitivity.allCases) { sensitivity in
                Text(sensitivity.localizedTitle)
            }
        } label: {
            Text("Sensitivity")
        }
        .badge(Text(globalSensitivity.representingSymbol.unicode!))
        
        Picker(selection: $globalDirection) {
            ForEach(Direction.allCases) { direction in
                Text(direction.localizedTitle)
            }
        } label: {
            Text("Direction")
        }
        .badge(Text(globalDirection.representingSymbol.unicode!))
        
        Divider()
        
        // MARK: - More Settings
        
        Toggle("Starts with macOS", isOn: $startsWithMacOS.isEnabled)
        
        SettingsLink(
            label: {
                Text("Settings…")
            },
            preAction: {
                for window in NSApp.windows where window.toolbar?.items != nil {
                    window.close()
                }
            },
            postAction: {
                for window in NSApp.windows where window.toolbar?.items != nil {
                    window.orderFrontRegardless()
                    window.center()
                }
            }
        )
        .keyboardShortcut(",", modifiers: .command)
        
        Button("About \(Bundle.main.appName)…") {
            NSApp.setActivationPolicy(.regular)
            AboutViewController.open()
        }
        .keyboardShortcut("i", modifiers: .command)
        
        Divider()
        
        Button("Quit") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
        .task {
            // MARK: Update conenction status
            
            for await _ in observationTrackingStream({ dial.hardware.connectionStatus }) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let connectionStatus = dial.hardware.connectionStatus
                    isConnected = connectionStatus.isConnected
                    
                    switch connectionStatus {
                    case .connected(let string):
                        serial = string
                    case .disconnected:
                        serial = nil
                    }
                }
            }
            
            // MARK: Update controller states
            
            for await _ in Defaults.updates([.controllerStates, .currentControllerIndex]) {
                controllerStates = Defaults.activatedControllerStates
            }
        }
    }
}

#Preview {
    MenuBarMenuView()
}
