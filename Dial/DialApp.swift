//
//  DialApp.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import SettingsAccess
import MenuBarExtraAccess

@main
struct DialApp: App {
    @State var isStatusItemPresented: Bool = false
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("Dial", image: "None") {
            SettingsLink(
                label: {
                    Text("Settings…")
                },
                preAction: {
                    for window in NSApp.windows where window.toolbar?.items != nil {
                        window.close()
                    }
                },
                postAction: {
                    for window in NSApp.windows where window.toolbar?.items != nil {
                        window.orderFrontRegardless()
                        window.center()
                    }
                }
            )
            .keyboardShortcut(",", modifiers: .command)
            
            Button("About \(Bundle.main.appName)") {
                
            }
            .keyboardShortcut("i", modifiers: .command)
            
            Divider()
            
            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .menuBarExtraStyle(.menu)
        .menuBarExtraAccess(isPresented: $isStatusItemPresented) { statusItem in
            guard
                let button = statusItem.button,
                button.subviews.count == 0
            else {
                return
            }
            
            let view = NSHostingView(rootView: StatusIconView())
            view.frame.size = NSSize(width: 50, height: 22)
            button.addSubview(view)
        }
    }
}
