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
            alert.alertStyle = NSAlert.Style.informational
            alert.messageText = String(
                format: NSLocalizedString(
                    "App/PermissionsAlert/Title",
                    value: "%@ needs Accessibility Permissions",
                    comment: "permissions alert title"
                ),
                Bundle.main.appName
            )
            alert.informativeText = String(
                format: NSLocalizedString(
                    "App/PermissionsAlert/Content",
                    value: """
%@ needs Accessibility permissions to perform dialing actions.

If you're updating, you might have to remove %@ from the list before re-granting the permissions.
""",
                    comment: "permissions alert content"),
                Bundle.main.appName, Bundle.main.appName
            )
            
            alert.runModal()
            
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
            let status = AXIsProcessTrustedWithOptions(options)
            
            return status
        }
    }
}
