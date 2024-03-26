//
//  Localizable.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation
import SwiftUI

protocol Localizable: Codable {
    var name: String { get }
    var title: String { get }
}

extension Localizable {
    var title: String {
        name
    }
}
