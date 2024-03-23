//
//  ConnectViaBluetoothTip.swift
//  Dial
//
//  Created by KrLite on 2024/3/22.
//

import Foundation
import TipKit

struct ConnectViaBluetoothTip: Tip {
    var title: Text {
        Text("Connect via Bluetooth")
    }
    
    var message: Text? {
        Text("Discover and connect to your device in Settings app so that \(Bundle.main.appName) is able to take charge of it. Click the reconnect button above when your device is ready.")
    }
    
    var image: Image? {
        Image(systemSymbol: .antennaRadiowavesLeftAndRight)
    }
    
    var actions: [Action] {
        [
            .init(perform: openBluetoothSettings) {
                Text("Open in Settings")
            }
        ]
    }
    
    func openBluetoothSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.BluetoothSettings") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}
