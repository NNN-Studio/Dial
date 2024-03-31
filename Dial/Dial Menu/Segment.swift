//
//  Segment.swift
//  Dial
//
//  Created by KrLite on 2024/3/31.
//

import SwiftUI

struct Segment: Shape {
    var angle: Double = .zero
    let diameter: CGFloat
    
    var animatableData: Double {
        get { self.angle }
        set { self.angle = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to:
                    CGPoint(
                        x: diameter / 2,
                        y: diameter / 2
                    )
        )
        path.addArc(
            center: CGPoint(
                x: diameter / 2,
                y: diameter / 2
            ),
            radius: diameter,
            startAngle: .degrees(angle - 22.5),
            endAngle: .degrees(angle + 22.5),
            clockwise: false
        )
        
        return path
    }
}
