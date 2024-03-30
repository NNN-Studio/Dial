//
//  ControllerDetailsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI

struct ControllerDetailsView: View {
    @Binding var id: ControllerID
    @State var name: String = ""
    
    @ViewBuilder
    func buildHeaderView(
        cornerSize: CGSize = .init(width: 24, height: 24),
        _ view: () -> some View
    ) -> some View {
        view()
            .background {
                Rectangle()
                    .fill(.separator.opacity(0.2))
                    .clipShape(.rect(cornerSize: cornerSize, style: .continuous))
            }
    }
    
    @ViewBuilder
    func buildShortcutsView() -> some View {
        // Shortcuts controller
        Group {
            let controller = id.controller as! ShortcutsController
            
            HStack {
                ControllerIconView(id: $id)
                    .imageScale(.large)
                    .frame(width: 24, height: 24)
                
                TextField(newControllerName, text: $name)
                //TextField(newControllerName, text: $id.controller.nameOrEmpty)
                    .textFieldStyle(.plain)
                    .controlSize(.large)
                    .font(.title3)
                
                Spacer()
            }
            .frame(height: 32)
            .padding()
            .padding(.horizontal, 16)
            
            Form {
                Section("Shortcuts") {
                    Text("1")
                    Text("2")
                }
                
                Section() {
                    Text("1")
                    Text("2")
                }
                
                Section("Configurations") {
                    Text("1")
                    Text("2")
                }
            }
            .formStyle(.grouped)
        }
    }
    
    @ViewBuilder
    func buildBuiltinView() -> some View {
        // Builtin controller
        Group {
            VStack {
                buildHeaderView {
                    HStack {
                        ControllerIconView(id: $id)
                            .imageScale(.large)
                            .frame(width: 24)
                        
                        Text(id.controller.nameOrEmpty)
                            .font(.title3)
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                }
                
                Text("Customizing options of a default controller are not applicable.")
                    .font(.caption)
                    .foregroundStyle(.placeholder)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
    
    var body: some View {
        buildBuiltinView()
            .orSomeView(condition: !id.isBuiltin, buildShortcutsView)
            .padding()
    }
}

#Preview("Builtin") {
    ControllerDetailsView(id: .constant(.builtin(.scroll)))
        .frame(width: 450, height: 450)
}

#Preview("Shortcuts") {
    ControllerDetailsView(id: .constant(.shortcuts(.init())))
        .frame(width: 450, height: 450)
}
