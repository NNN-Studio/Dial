//
//  GeneralSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import TipKit

struct GeneralSettingsView: View {
    @EnvironmentObject var dial: SurfaceDial
    var connectViaBluetoothTip = ConnectViaBluetoothTip()
    
    var body: some View {
        VStack {
            Image("Model", label: Text("Dial"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 175, alignment: .center)
                .padding(.vertical, 30)
                .opacity(dial.hardware.isConnected ? 1 : 0.25)
            
            HStack {
                Text(dial.hardware.connectionStatus.localizedName)
                    .foregroundStyle(.placeholder)
                    .fontDesign(.monospaced)
                
                Button {
                    dial.connect()
                } label: {
                    Image(systemSymbol: .arrowTriangle2CirclepathCircleFill)
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .controlSize(.extraLarge)
                .tint(dial.hardware.isConnected ? .green : .red)
            }
            
            TipView(connectViaBluetoothTip)
                .tint(.primary)
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
        .environmentObject(SurfaceDial())
        .frame(width: 450)
}
