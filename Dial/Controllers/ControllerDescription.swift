//
//  ControllerDescription.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI

struct ControllerDescription: Codable, Hashable {
    var abstraction: String
    var warning: String = ""
    
    var rotateClockwisely: String = ""
    var rotateCounterclockwisely: String = ""
    
    var press: String = ""
    var doublePress: String = ""
    
    var pressAndRotateClockwisely: String = ""
    var pressAndRotateCounterclockwisely: String = ""
}
