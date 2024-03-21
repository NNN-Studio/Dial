//
//  SFSymbol+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import SFSafeSymbols
import AppKit

extension SFSymbol {
    static let circleFillableSuffix = ".circle.fill"
    
    static let circleFillableFallback: SFSymbol = .gear
    
    static var circleFillableSymbols: [SFSymbol] {
        SFSymbol.allSymbols
            .filter { $0.hasSuffix(SFSymbol.circleFillableSuffix) && $0.withoutSuffix(SFSymbol.circleFillableSuffix) != nil }
            .map { $0.withoutSuffix(SFSymbol.circleFillableSuffix)! }
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
    var isCircleFillable: Bool {
        SFSymbol.circleFillableSymbols.contains(self)
    }
    
    var image: NSImage {
        NSImage(systemSymbol: self)
    }
    
    var circleFilledImage: NSImage {
        NSImage(systemSymbol: self.withSuffix(SFSymbol.circleFillableSuffix) ?? .circleFillableFallback)
    }
}

extension SFSymbol: Codable {
    // Make it codable
}

extension SFSymbol {
    // Toxic
    var unicode: String? {
        if self == .hexagon { return "􀝝" }
        if self == .rays { return "􀇯" }
        if self == .slowmo { return "􀇱" }
        if self == .timelapse { return "􀇲" }
        if self == .circleCircle { return "􀨁" }
        
        if self == .digitalcrownHorizontalArrowClockwiseFill { return "􀻲" }
        if self == .digitalcrownHorizontalArrowCounterclockwiseFill { return "􀻴" }
        
        return nil
    }
}

