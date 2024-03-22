//
//  ConnectViaBluetoothTip.swift
//  Dial
//
//  Created by KrLite on 2024/3/22.
//

import Foundation
import TipKit

struct ConnectViaBluetoothTip: Tip {
    @Parameter(.transient)
    static var isConnected: Bool = false
    
    var title: Text {
        Text("Connect via Bluetooth")
    }
    
    var message: Text? {
        Text("Discover and connect to your device in Settings app so that \(Bundle.main.appName) is able to take charge of it. Click the reconnect button above to tell \(Bundle.main.appName) that your device is ready.")
    }
    
    var image: Image? {
        Image(systemSymbol: .antennaRadiowavesLeftAndRight)
    }
    
    var options: [any TipOption] {
        [
            IgnoresDisplayFrequency(true)
        ]
    }
    
    var rules: [Rule] {
        #Rule(Self.$isConnected) { !$0 }
    }
}
