//
//  IconChooserView.swift
//  Dial
//
//  Created by KrLite on 2024/3/29.
//

import SwiftUI
import SFSafeSymbols

struct IconChooserView: View {
    @Binding var chosen: SFSymbol
    @State var hovering: SFSymbol?
    
    let columns: [GridItem] = .init(repeating: .init(.fixed(50)), count: 5)
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(SFSymbol.__circleFillableSymbols) { symbol in
                    Button {
                        chosen = symbol
                    } label: {
                        Image(systemSymbol: symbol)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                    }
                    .onHover { isHovering in
                        hovering = isHovering ? symbol : nil
                    }
                    .buttonStyle(.borderless)
                    .tint(chosen == symbol ? .accentColor : .secondary)
                    .background(.separator.opacity(symbol == hovering ? 1 : 0), in: .circle)
                }
            }
            .padding()
        }
    }
}

#Preview {
    IconChooserView(chosen: .constant(.__circleFillableFallback))
        .frame(height: 420)
}
