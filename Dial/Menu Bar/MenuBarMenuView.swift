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
    
    @Default(.activatedControllerIDs) var activatedControllerIDs
    @Default(.currentControllerID) var currentControllerID
    
    @Default(.globalHapticsEnabled) var globalHapticsEnabled
    @Default(.globalSensitivity) var globalSensitivity
    @Default(.globalDirection) var globalDirection
    
    @ObservedObject var startsWithMacOS = LaunchAtLogin.observable
    
    func possibleChar(from int: Int) -> Character? {
        return String(int).first
    }
    
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
        
        Text("Controllers")
            .badge(Text("press and hold dial"))
        
        ForEach(Array($activatedControllerIDs.enumerated()), id: \.offset) { index, id in
            Toggle(isOn: id.isCurrent) {
                Image(systemSymbol: id.wrappedValue.controller.symbol)
                Text(id.wrappedValue.controller.name ?? controllerNamePlaceholder)
            }
            .possibleKeyboardShortcut(
                possibleChar(from: index).map { KeyEquivalent.init($0) },
                modifiers: .option
            )
        }
        
        Divider()
        
        // MARK: - Quick Settings
        
        Text("Quick Settings")
        
        Toggle(isOn: $globalHapticsEnabled) {
            Text(.init(localized: .init("Menu: Haptics", defaultValue: "Haptics Feedback")))
        }
        
        Picker(selection: $globalSensitivity) {
            ForEach(Sensitivity.allCases) { sensitivity in
                Text(sensitivity.title)
            }
        } label: {
            Text(.init(localized: .init("Menu: Sensitivity", defaultValue: "Sensitivity")))
        }
        .badge(Text(globalSensitivity.symbol.unicode!))
        
        Picker(selection: $globalDirection) {
            ForEach(Direction.allCases) { direction in
                Text(direction.title)
            }
        } label: {
            Text(.init(localized: .init("Menu: Direction", defaultValue: "Direction")))
        }
        .badge(Text(globalDirection.symbol.unicode!))
        
        Divider()
        
        // MARK: - More Settings
        
        Toggle(isOn: $startsWithMacOS.isEnabled) {
            Text(.init(localized: .init("Menu: Starts with macOS", defaultValue: "Starts with macOS")))
        }
        
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
        }
    }
}

#Preview {
    MenuBarMenuView()
}
