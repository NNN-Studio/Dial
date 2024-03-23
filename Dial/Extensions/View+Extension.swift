//
//  View+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/23.
//

import Foundation
import SwiftUI

extension View {
    func or(condition: Bool, _ another: () -> Self) -> Self {
        condition ? another() : self
    }
    
    func orAnyView(condition: Bool, _ another: () -> any View) -> any View {
        condition ? another() : self
    }
}
