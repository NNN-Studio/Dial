//
//  SFSymbol+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import SFSafeSymbols
import AppKit
import SwiftUI

extension SFSymbol {
    static let __circleFillableSuffix = ".circle.fill"
    
    static let __circleFillableFallback: SFSymbol = .gear
    
    static var __circleFillableSymbols: [SFSymbol] {
        SFSymbol.allSymbols
            .filter { $0.hasSuffix(SFSymbol.__circleFillableSuffix) && $0.withoutSuffix(SFSymbol.__circleFillableSuffix) != nil }
            .map { $0.withoutSuffix(SFSymbol.__circleFillableSuffix)! }
            .sorted { $0.rawValue < $1.rawValue } // Sort naturally
    }
    
    func hasSuffix(_ suffix: String) -> Bool {
        rawValue.hasSuffix(suffix)
    }
    
    func withSuffix(_ suffix: String) -> SFSymbol? {
        let name = rawValue + "." + suffix.replacing(/^\./, with: "")
        return SFSymbol.allSymbols.filter { $0.rawValue == name }.first
    }
    
    func withoutSuffix(_ suffix: String) -> SFSymbol? {
        guard hasSuffix(suffix) else { return nil }
        
        let name = rawValue.replacing("." + suffix.replacing(/^\./, with: ""), with: "")
        return SFSymbol.allSymbols.filter { $0.rawValue == name }.first
    }
}

extension SFSymbol {
    var __isCircleFillable: Bool {
        SFSymbol.__circleFillableSymbols.contains(self)
    }
    
    var __circleFilled: SFSymbol {
        self.withSuffix(SFSymbol.__circleFillableSuffix) ?? .__circleFillableFallback
    }
    
    var __image: Image {
        Image(systemSymbol: self)
    }
    
    var __circleFilledImage: Image {
        __circleFilled.__image
    }
}

extension SFSymbol: Codable {
    // Make it codable
}

extension SFSymbol: Identifiable {
    // Make it identifiable
}

extension SFSymbol {
    // Toxic
    var unicode: String? {
        switch self {
        case .hexagon: "􀝝"
        case .rays: "􀇯"
        case .slowmo: "􀇱"
        case .timelapse: "􀇲"
        case .circleCircle: "􀨁"
            
        case .directcurrent: "􀯝"
        case .alternatingcurrent: "􁆭"
            
        case .digitalcrownHorizontalArrowClockwiseFill: "􀻲"
        case .digitalcrownHorizontalArrowCounterclockwiseFill: "􀻴"
            
        default: nil
        }
    }
}

