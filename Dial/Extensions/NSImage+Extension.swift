//
//  NSImage+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import AppKit

extension NSImage {
    func withVerticalPadding(_ padding: CGFloat) -> NSImage {
        let scalar = 1 - min(1, padding / size.width)
        let innerSize = size.applying(CGAffineTransform(scaleX: scalar, y: scalar))
        let image = NSImage(size: NSSize(width: innerSize.width, height: size.height))
        
        image.lockFocus()
        
        draw(in: NSRect(
            origin: NSPoint(x: 0, y: padding / 2),
            size: innerSize
        ))
        
        image.unlockFocus()
        
        return image
    }
    
    func horizontallyCombine(with image: NSImage?, padding: CGFloat = 4) -> NSImage {
        if let image {
            let newSize = NSSize(width: size.width + padding + image.size.width, height: max(size.height, image.size.height))
            let combinedImage = NSImage(size: newSize)
            
            combinedImage.lockFocus()
            
            draw(
                at: NSPoint(
                    x: 0,
                    y: (newSize.height - size.height) / 2
                ),
                from: NSZeroRect,
                operation: .copy,
                fraction: 1.0
            )
            image.draw(
                at: NSPoint(
                    x: size.width + padding,
                    y: (newSize.height - image.size.height) / 2
                ),
                from: NSZeroRect,
                operation: .copy,
                fraction: 1.0
            )
            
            combinedImage.unlockFocus()
            
            return combinedImage
        } else {
            return self
        }
    }
    
    func fitIntoStatusBar() -> NSImage {
        let scalar = NSStatusBar.system.thickness / size.height
        let image = self
        
        image.size = size.applying(CGAffineTransform(scaleX: scalar, y: scalar))
        
        return image
    }
}

