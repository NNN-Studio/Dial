//
//  GeneralSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import TipKit

struct GeneralSettingsView: View {
    let connectViaBluetoothTip = ConnectViaBluetoothTip()
    
    @State var reconnectButtonHasPerformed = false
    @State var isConnected: Bool = false
    @State var serial: String? = nil
    
    var body: some View {
        VStack {
            Image("Model", label: Text("Dial"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 175, alignment: .center)
                .padding(.vertical, 30)
                .opacity(isConnected ? 1 : 0.25)
            
            HStack {
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
            }
            
            TipView(connectViaBluetoothTip)
                .padding(.horizontal, 20)
            
            Form {
                Section("Behavior") {
                    Text("Test")
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
        .frame(width: 450)
}
