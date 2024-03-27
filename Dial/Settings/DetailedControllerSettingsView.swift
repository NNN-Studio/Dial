//
//  DetailedControllerSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/27.
//

import SwiftUI

struct DetailedControllerSettingsView: View {
    @Binding var id: ControllerID
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview("Builtin") {
    DetailedControllerSettingsView(id: .constant(.builtin(.scroll)))
}

#Preview("Shortcuts") {
    DetailedControllerSettingsView(id: .constant(.shortcuts(ShortcutsController.Settings())))
}
