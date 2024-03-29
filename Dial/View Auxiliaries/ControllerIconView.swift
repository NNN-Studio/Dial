//
//  ControllerIconView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI

struct ControllerIconView: View {
    @Binding var id: ControllerID
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemSymbol: id.controller.symbol)
        }
        .buttonStyle(.borderless)
        .orSomeView(condition: id.isBuiltin) {
            Image(systemSymbol: id.controller.symbol)
        }
        .aspectRatio(1, contentMode: .fill)
    }
}
