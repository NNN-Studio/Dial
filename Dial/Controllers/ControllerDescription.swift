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
    
    static let example: ControllerDescription = .init(
        abstraction: "Abstraction. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in dictum non consectetur a erat nam at.",
        warning: "Warning! Risus pretium quam vulputate dignissim suspendisse in est ante in nibh mauris cursus mattis molestie a!",
        rotateClockwisely: "Rotate clockwisely. Sed euismod nisi porta lorem mollis aliquam ut porttitor leo a diam sollicitudin tempor id eu.",
        rotateCounterclockwisely: "Rotate counterclockwisely. Lorem ipsum dolor sit amet consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo nulla.",
        press: "Press. Lorem ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant morbi tristique senectus et netus et.",
        doublePress: "Double press. Pulvinar neque laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt eget nullam non nisi est.",
        pressAndRotateClockwisely: "Press and rotate clockwisely. Facilisi morbi tempus iaculis urna id volutpat lacus laoreet non curabitur gravida arcu ac tortor dignissim.",
        pressAndRotateCounterclockwisely: "Press and rotate counterclockwisely. Venenatis lectus magna fringilla urna porttitor rhoncus dolor purus non enim praesent elementum facilisis leo vel."
    )
}
