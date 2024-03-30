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
    
    let columns: [GridItem] = [.init(.adaptive(minimum: 50, maximum: 100))]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(SFSymbol.__circleFillableSymbols) { symbol in
                        IconCellView(
                            chosen: $chosen,
                            symbol: symbol
                        )
                    }
                }
                .padding()
                .onChange(of: chosen, initial: true) {
                    withAnimation {
                        proxy.scrollTo(chosen)
                    }
                }
            }
        }
    }
}

#Preview {
    struct Wrapper: View {
        @State var chosen: SFSymbol = .__circleFillableFallback
        
        var body: some View {
            IconChooserView(chosen: $chosen)
                .frame(width: 300, height: 420)
        }
    }
    
    return Wrapper()
}

struct IconCellView: View {
    @Binding var chosen: SFSymbol
    var symbol: SFSymbol
    
    // For animations
    @State var count: Int = 0
    
    var body: some View {
        Button {
            count += 1
            withAnimation {
                chosen = symbol
            }
        } label: {
            Image(systemSymbol: symbol)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .bold()
                .symbolEffect(.bounce, value: count)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(chosen == symbol ? Color.accentColor : Color.secondary)
        .background(chosen == symbol ? Color.accentColor.opacity(0.1) : Color.clear, in: .capsule)
        .id(symbol)
    }
}
