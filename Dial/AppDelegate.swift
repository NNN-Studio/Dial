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
        PermissionsManager.requestAccess()
    }
}
