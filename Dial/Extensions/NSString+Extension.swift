//
//  NSString+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation

extension NSString {
    convenience init(wcharArray: UnsafeMutablePointer<wchar_t>) {
        self.init(
            bytes: UnsafePointer(wcharArray),
            length: wcslen(wcharArray) * MemoryLayout<wchar_t>.stride,
            encoding: String.Encoding.utf32LittleEndian.rawValue
        )!
    }
}
