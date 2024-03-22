//
//  GeneralSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var dial: SurfaceDial
    
    var body: some View {
        VStack {
            Image("Model", label: Text("Dial"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 175, alignment: .center)
                .padding(.vertical, 30)
            
            HStack {
                Text(dial.hardware.connectionStatus.localizedName)
                    .foregroundStyle(.placeholder)
                    .fontDesign(.monospaced)
                
                Button {
                    dial.reconnect()
                } label: {
                    Image(systemSymbol: .arrowTriangle2CirclepathCircleFill)
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .controlSize(.extraLarge)
                .tint(dial.hardware.isConnected ? .green : .red)
            }
            
            Form {
                Section("Behavior") {
                    
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
