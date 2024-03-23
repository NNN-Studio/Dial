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
    
    @State var reconnectButtonHasPerformed = false
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
                .buttonStyle(.borderless)
                .controlSize(.extraLarge)
                .tint(isConnected ? .green : .red)
                .frame(width: 50, alignment: .leading)
            }
            
            TipView(connectViaBluetoothTip)
                .padding(.horizontal, 20)
                .transition(.asymmetric(
                    insertion: .push(from: .top),
                    removal: .push(from: .top))
                )
            
            Form {
                Section("Global Behavior") {
                    Toggle(isOn: $globalHapticsEnabled) {
                        Text("Haptics feedback")
                    }
                }
                
                Section {
                    Picker(selection: $globalSensitivity) {
                        ForEach(Sensitivity.allCases) { sensitivity in
                            Text(sensitivity.localizedTitle)
                        }
                    } label: {
                        HStack {
                            Text("Sensitivity")
                            Image(systemSymbol: globalSensitivity.representingSymbol)
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    Picker(selection: $globalDirection) {
                        ForEach(Direction.allCases) { direction in
                            Text(direction.localizedTitle)
                        }
                    } label: {
                        HStack {
                            Text("Direction")
                            Image(systemSymbol: globalDirection.representingSymbol)
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
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
                            
                            Text("Hides menu bar item while device disconnected. Re-open \(Bundle.main.appName) to see this window.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                    }
                }
                
                Section {
                    Toggle(isOn: $startsWithMacOS.isEnabled) {
                        Text("Starts with macOS")
                    }
                }
            }
            .formStyle(.grouped)
            .scrollDisabled(true)
        }
        .task {
            Task { @MainActor in
                for await connectionStatus in observationTrackingStream({ dial.hardware.connectionStatus }) {
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
