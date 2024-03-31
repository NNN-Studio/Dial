//
//  AboutViewController.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI

class AboutViewController {
    static var aboutWindowController: NSWindowController?
    
    static func open() {
        if aboutWindowController == nil {
            let window = NSWindow()
            
            window.styleMask = [.closable, .titled, .fullSizeContentView]
            window.title = String(
                format:
                    NSLocalizedString(
                        "About View Controller: Title",
                        value: "About %@",
                        comment: "about view controller title"
                    ),
                Bundle.main.appName
            )
            window.contentView = NSHostingView(rootView: AboutView())
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            
            window.center()
            
            aboutWindowController = .init(window: window)
        } else {
            // Refresh view
            aboutWindowController?.window?.contentView = NSHostingView(rootView: AboutView())
        }
        
        aboutWindowController?.showWindow(aboutWindowController?.window)
        aboutWindowController?.window?.orderFrontRegardless()
    }
}
