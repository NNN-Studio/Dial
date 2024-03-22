//
//  PermissionsManager.swift
//  Dial
//
//  Created by KrLite on 2024/3/22.
//

import Foundation
import AppKit

class PermissionsManager {
    static func requestAccess() {
        PermissionsManager.Accessibility.requestAccess()
    }
    
    class Accessibility {
        static func getStatus() -> Bool {
            // Get current state for accessibility access
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: false]
            let status = AXIsProcessTrustedWithOptions(options)
            
            return status
        }
        
        @discardableResult
        static func requestAccess() -> Bool {
            // More information on this behaviour: https://stackoverflow.com/questions/29006379/accessibility-permissions-reset-after-application-update
            guard !PermissionsManager.Accessibility.getStatus()  else { return true }
            
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("App/PermissionsAlert/Title", value: "Permissions Required", comment: "permissions alert title")
            alert.alertStyle = NSAlert.Style.informational
            alert.informativeText = NSLocalizedString(
                "App/PermissionsAlert/Content",
                value: """
\(Bundle.main.appName) needs Accessibility permissions to function properly.
Due to an issue in macOS, if you're upgrading from an earlier version, you might have to remove \(Bundle.main.appName) from the accessibility permissions before restarting the app to re-add the permissions.
""",
                comment: "permissions alert content")
            
            alert.runModal()
            
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
            let status = AXIsProcessTrustedWithOptions(options)
            
            return status
        }
    }
}
