//
//  Defaults+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Defaults

extension Defaults {
    public static let haptics = Key<Bool>("haptics", default: true)
    public static let statusItem = Key<Bool>("statusItem", default: true)
    public static let statusItemAutoHidden = Key<Bool>("statusItemAutoHidden", default: false)
}
