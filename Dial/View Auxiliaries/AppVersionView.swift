//
//  AppVersionView.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI

struct AppVersionView: View {
    var body: some View {
        HStack {
            Text("Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))")
            
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(
                    "\(Bundle.main.appVersion) (\(Bundle.main.appBuild))",
                    forType: NSPasteboard.PasteboardType.string
                )
            }, label: {
                Image(systemSymbol: .clipboardFill)
            })
            .buttonStyle(.plain)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    AppVersionView()
}
