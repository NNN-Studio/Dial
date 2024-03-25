//
//  ShrinkableEqualWidthVStack.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import Foundation
import SwiftUI

struct ShrinkableEqualWidthVStack: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let totalSpacing = spacing.reduce(0) { $0 + $1 }
        
        return CGSize(
            width: maxSize.width,
            height: maxSize.height * CGFloat(subviews.count) + totalSpacing
        )
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }
        
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let sizeThatFits = sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
        
        let placementProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var y = bounds.midY - sizeThatFits.height / 2 + maxSize.height / 2
        
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: bounds.midX, y: y),
                anchor: .center,
                proposal: placementProposal
            )
            
            y += maxSize.height + spacing[index]
        }
    }
    
    private func maxSize(subviews: Subviews) -> CGSize {
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxSize: CGSize = subviewSizes.reduce(.zero) { currentMax, subviewSize in
            CGSize(
                width: max(currentMax.width, subviewSize.width),
                height: max(currentMax.height, subviewSize.height))
        }
        
        return maxSize
    }
    
    private func spacing(subviews: Subviews) -> [CGFloat] {
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .vertical
            )
        }
    }
}
