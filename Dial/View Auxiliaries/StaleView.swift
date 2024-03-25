//
//  StaleView.swift
//  Dial
//
//  Created by KrLite on 2024/3/25.
//

import SwiftUI

struct StaleView: View {
    var body: some View {
        Image(systemSymbol: .aqiMedium)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: true)
            .opacity(0.2)
    }
}

#Preview {
    StaleView()
}
