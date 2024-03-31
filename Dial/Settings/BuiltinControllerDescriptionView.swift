//
//  BuiltinControllerDescriptionView.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI

struct BuiltinControllerDescriptionView: View {
    var description: ControllerDescription
    
    var body: some View {
        VStack {
            Text(description.abstraction)
                .foregroundStyle(.secondary)
                .font(.caption)
            
            Text(description.warning)
                .foregroundStyle(.red)
                .font(.caption)
            
            Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                if !description.rotateClockwisely.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalArrowClockwise)
                            .help("Rotate clockwisely")
                            .foregroundStyle(.secondary)
                        
                        Text(description.rotateClockwisely)
                    }
                }
                
                if !description.rotateCounterclockwisely.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwise)
                            .help("Rotate counterclockwisely")
                            .foregroundStyle(.secondary)
                        
                        Text(description.rotateCounterclockwisely)
                    }
                }
                
                if !description.press.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalPress)
                            .help("Press")
                            .foregroundStyle(.secondary)
                        
                        Text(description.press)
                    }
                }
                
                if !description.doublePress.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalPressFill)
                            .help("Double press")
                            .foregroundStyle(.secondary)
                        
                        Text(description.doublePress)
                    }
                }
                
                if !description.pressAndRotateClockwisely.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalArrowClockwiseFill)
                            .help("Press and rotate clockwisely")
                            .foregroundStyle(.secondary)
                        
                        Text(description.pressAndRotateClockwisely)
                    }
                }
                
                if !description.pressAndRotateCounterclockwisely.isEmpty {
                    GridRow(alignment: .top) {
                        Image(systemSymbol: .digitalcrownHorizontalArrowCounterclockwiseFill)
                            .help("Press and rotate counterclockwisely")
                            .foregroundStyle(.secondary)
                        
                        Text(description.pressAndRotateCounterclockwisely)
                    }
                }
            }
            .padding(.top, 16)
        }
    }
}

#Preview {
    BuiltinControllerDescriptionView(description: .example)
        .frame(width: 450)
}
