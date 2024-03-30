//
//  ControllerIconView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI

struct ControllerIconView: View {
    @Binding var id: ControllerID
    
    @State var isPopoverPresented: Bool = false
    
    var body: some View {
        Button {
            isPopoverPresented.toggle()
        } label: {
            Image(systemSymbol: id.controller.symbol)
                .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(.borderless)
        .orSomeView(condition: id.isBuiltin) {
            Image(systemSymbol: id.controller.symbol)
        }
        .popover(isPresented: $isPopoverPresented) {
            IconChooserView(chosen: $id.controller.symbol)
                .frame(width: 300, height: 420)
        }
    }
}
