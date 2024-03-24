//
//  AppDelegate.swift
//  Dial
//
//  Created by KrLite on 2024/3/22.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Force load dial instance
        print("!!! Force loaded \(dial) !!!")
        
        PermissionsManager.requestAccess()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.accessory)
        return false
    }
}
