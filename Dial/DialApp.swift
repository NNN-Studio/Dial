//
//  DialApp.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import MenuBarExtraAccess

var dial: SurfaceDial = .init()

func notifyTaskStart(_ message: String, _ sender: Any? = nil) {
    print("!!! Task started: \(message) !!!", terminator: "")
    if let sender {
        print(" (\(String(describing: type(of: sender))))", terminator: "")
    }
    print()
}

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

@main
struct DialApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isMenuBarItemPresented: Bool = false
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
        
        MenuBarExtra("Dial", image: "None") {
            MenuBarMenuView()
        }
        .menuBarExtraStyle(.menu)
        .menuBarExtraAccess(isPresented: $isMenuBarItemPresented) { menuBarItem in
            guard
                // Init once
                let button = menuBarItem.button,
                button.subviews.count == 0
            else { return }
            
            menuBarItem.length = 40
            
            let view = NSHostingView(rootView: MenuBarIconView())
            view.frame.size = .init(width: 40, height: NSStatusBar.system.thickness)
            button.addSubview(view)
        }
    }
}
