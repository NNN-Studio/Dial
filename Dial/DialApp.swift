//
//  DialApp.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import SettingsAccess
import MenuBarExtraAccess

var dial: SurfaceDial = .init()

@main
struct DialApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isMenuBarItemPresented: Bool = false
    
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
        .menuBarExtraAccess(isPresented: $isMenuBarItemPresented) { menuBarItem in
            guard
                // Init once
                let button = menuBarItem.button,
                button.subviews.count == 0
            else { return }
            
            menuBarItem.length = 32
            
            let view = NSHostingView(rootView: MenuBarIconView())
            view.frame.size = .init(width: 32, height: NSStatusBar.system.thickness)
            button.addSubview(view)
        }
    }
}
