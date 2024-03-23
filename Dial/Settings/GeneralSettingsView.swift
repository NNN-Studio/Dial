//
//  GeneralSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import TipKit

struct GeneralSettingsView: View {
    var connectViaBluetoothTip = ConnectViaBluetoothTip()
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
                Text(serial ?? "SURFACE DIAL DISCONNECTED")
                    .foregroundStyle(.placeholder)
                    .fontDesign(.monospaced)
                
                Button {
                    dial.connect()
                    connectViaBluetoothTip.invalidate(reason: .actionPerformed)
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
    }
}

#Preview {
    GeneralSettingsView()
        .frame(width: 450)
}
