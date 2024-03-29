//
//  ControllerDetailsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI

struct ControllerDetailsView: View {
    @Binding var id: ControllerID
    
    func buildShortcutsView() -> some View {
        // Shortcuts controller
        Group {
            let controller = id.controller as! ShortcutsController
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemSymbol: id.controller.symbol)
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .aspectRatio(1, contentMode: .fill)
                
                Text(id.controller.nameOrEmpty)
                    .font(.title3)
                
                Spacer()
            }
        }
    }
    
    func buildBuiltinView() -> some View {
        // Builtin controller
        Group {
            HStack {
                Button {
                    
                } label: {
                    Image(systemSymbol: id.controller.symbol)
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .aspectRatio(1, contentMode: .fill)
                
                Text(id.controller.nameOrEmpty)
                    .font(.title3)
            }
        }
    }
    
    var body: some View {
        buildBuiltinView()
            .orSomeView(condition: !id.isBuiltin, buildShortcutsView)
            .padding()
    }
}

#Preview {
    HStack {
        ControllerDetailsView(id: .constant(.builtin(.scroll)))
            .frame(minWidth: 300)
        
        Divider()
        
        ControllerDetailsView(id: .constant(.shortcuts(.init())))
            .frame(minWidth: 300)
    }
    .frame(height: 600)
}
