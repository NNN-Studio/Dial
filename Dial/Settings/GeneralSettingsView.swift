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
    
    var body: some View {
        VStack {
            Image("Model", label: Text("Dial"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 175, alignment: .center)
                .padding(.vertical, 30)
                .opacity(true ? 1 : 0.25)
            
            HStack {
                Text("")
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
                .tint(true ? .green : .red)
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
        .frame(width: 450)
}
