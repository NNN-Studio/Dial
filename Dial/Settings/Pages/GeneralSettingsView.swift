//
//  GeneralSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import TipKit
import Defaults
import LaunchAtLogin

struct GeneralSettingsView: View {
    let connectViaBluetoothTip = ConnectViaBluetoothTip()
    
    @State var reconnectButtonHasPerformed: Bool = false
    @State var isConnected: Bool = false
    @State var serial: String? = nil
    
    @Default(.globalHapticsEnabled) var globalHapticsEnabled
    @Default(.globalSensitivity) var globalSensitivity
    @Default(.globalDirection) var globalDirection
    
    @Default(.menuBarItemEnabled) var menuBarItemEnabled
    @Default(.menuBarItemAutoHidden) var menuBarItemAutoHidden
    
    @ObservedObject var startsWithMacOS = LaunchAtLogin.observable
    
    var body: some View {
        VStack {
            // MARK: - Model
            
            Image("Model", label: Text("Dial"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 175, alignment: .center)
                .padding(.vertical, 30)
                .opacity(isConnected ? 1 : 0.25)
                .animation(.easeInOut, value: isConnected)
            
            HStack {
                Spacer()
                    .frame(width: 50)
                
                Text("SURFACE DIAL DISCONNECTED")
                    .or(condition: isConnected) {
                        Text(serial ?? "")
                    }
                    .foregroundStyle(.placeholder)
                    .fontDesign(.monospaced)
                
                Button {
                    dial.connect()
                    reconnectButtonHasPerformed = true
                } label: {
                    Image(systemSymbol: isConnected ? .checkmarkCircleFill : .arrowTriangle2CirclepathCircleFill)
                        .imageScale(.large)
                }
                .popoverTip(connectViaBluetoothTip, arrowEdge: .trailing)
                .buttonStyle(.borderless)
                .controlSize(.extraLarge)
                .tint(isConnected ? .green : .red)
                .frame(width: 50, alignment: .leading)
            }
            
            // MARK: - Settings
            
            Form {
                Section("Menu Bar Item") {
                    Toggle(isOn: $menuBarItemEnabled) {
                        Text("Shows menu bar item")
                        
                        if !menuBarItemEnabled {
                            Text("Re-open \(Bundle.main.appName) to see this window.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                    }
                    
                    if menuBarItemEnabled {
                        Toggle(isOn: $menuBarItemAutoHidden) {
                            Text("Auto hides menu bar item")
                            
                            Text("Hides menu bar item while device disconnected. To see this window again, please re-open \(Bundle.main.appName).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                    }
                }
                
                Section("Global Behavior") {
                    Toggle(isOn: $globalHapticsEnabled) {
                        Text("Haptic feedback")
                    }
                }
                
                Section {
                    Picker("Sensitivity", selection: $globalSensitivity) {
                        ForEach(Sensitivity.allCases) { sensitivity in
                            Text(sensitivity.name)
                        }
                    }
                    .badge(Text(globalSensitivity.symbol.unicode!))
                    
                    Picker("Direction", selection: $globalDirection) {
                        ForEach(Direction.allCases) { direction in
                            Text(direction.name)
                        }
                    }
                    .badge(Text(globalDirection.symbol.unicode!))
                }
                
                Section {
                    Toggle("Starts with macOS", isOn: $startsWithMacOS.isEnabled)
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
        }
        .task {
            // MARK: Update connection status
            
            for await _ in observationTrackingStream({ dial.hardware.connectionStatus }) {
                // Due to a strange delay in `connectionStatus`, we need this async block to guarantee the correct result.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let connectionStatus = dial.hardware.connectionStatus
                    isConnected = connectionStatus.isConnected
                    
                    if reconnectButtonHasPerformed && isConnected {
                        ConnectViaBluetoothTip.didConnect.sendDonation()
                    }
                    
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
    GeneralSettingsView()
        .frame(width: 450, height: 1200)
}
