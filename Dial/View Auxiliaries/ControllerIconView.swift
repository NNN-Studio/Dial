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
        ZStack {
            Button {
                isPopoverPresented.toggle()
            } label: {
                Image(systemSymbol: id.controller.symbol)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.borderless)
            .orSomeView(condition: id.isBuiltin) {
                Image(systemSymbol: id.controller.symbol)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .popover(isPresented: $isPopoverPresented, arrowEdge: .leading) {
            IconChooserView(chosen: $id.controller.symbol)
                .frame(width: 300, height: 420)
        }
    }
}
