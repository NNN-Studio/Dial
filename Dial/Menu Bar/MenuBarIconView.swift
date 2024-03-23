//
//  MenuBarIconView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import SFSafeSymbols
import Defaults

struct MenuBarIconView: View {
    @State var isConnected: Bool = false
    @State var controllerSymbol: SFSymbol?
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemSymbol: .hockeyPuckFill)
                .imageScale(.large)
            
            if let controllerSymbol {
                Image(systemSymbol: controllerSymbol)
            }
        }
        .opacity(isConnected ? 1 : 0.2)
        .animation(.easeInOut, value: isConnected)
        .task {
            Task { @MainActor in
                for await connectionStatus in observationTrackingStream({ dial.hardware.connectionStatus }) {
                    isConnected = connectionStatus.isConnected
                }
            }
            
            Task { @MainActor in
                for await _ in Defaults.updates(.currentControllerIndex) {
                    if let controller = Defaults.currentController {
                        controllerSymbol = controller.representingSymbol
                    } else {
                        controllerSymbol = nil
                    }
                }
            }
        }
    }
}
