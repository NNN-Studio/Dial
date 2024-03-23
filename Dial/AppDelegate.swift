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
        // Force load dial instance
        print("!!! Force loaded \(dial) !!!")
        
        PermissionsManager.requestAccess()
    }
}
