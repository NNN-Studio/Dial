//
//  DialMenuView.swift
//  Dial
//
//  Created by KrLite on 2024/3/31.
//

import SwiftUI
import Combine
import Defaults

/*
struct RadialMenuView: View {
    let diameter: CGFloat = 100
    
    @Default(.currentControllerID) var current
    @Default(.activatedControllerIDs) var available
    
    private let isPreview: Bool
    
    @State var angle: Double = .zero
    @State var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    @Default(.dialMenuThickness) var thickness
    @Default(.dialMenuAnimation) var animation
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
        
        if isPreview {
            self._timer = State(initialValue: Timer.publish(every: 1, on: .main, in: .common).autoconnect())
        } else {
            self._timer = State(initialValue: Timer.publish(every: -1, on: .main, in: .common).autoconnect())
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                ZStack {
                    ZStack {
                        VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                        
                        Rectangle()
                            .fill(.accentColor)
                            .mask {
                                Color.clear
                                    .overlay {
                                        ZStack {
                                            if self.currentAction.direction.shouldFillRadialMenu {
                                                Color.white
                                            }
                                            
                                            ZStack {
                                                Segment(angle: angle, diameter: diameter)
                                            }
                                            .compositingGroup()
                                        }
                                    }
                            }
                        
                        Circle()
                            .stroke(.quinary, lineWidth: 2)
                        
                        Circle()
                            .stroke(.quinary, lineWidth: 2)
                            .padding(thickness.number)
                    }
                    .mask {
                        Circle()
                    }
                }
                .frame(width: diameter, height: diameter)
                
                Spacer()
            }
            
            Spacer()
        }
        .shadow(radius: 10)
        .animation(animation.animation, value: current)
        .onChange(of: current) { _ in
            if let index = available.firstIndex(of: current) {
                let closestAngle: Angle = .degrees(angle).angleDifference(to: target)
                let animate: Bool = abs(closestAngle.degrees) < 179
                
                let defaultAnimation = AnimationConfiguration.fast.radialMenuAngle
                let noAnimation = Animation.linear(duration: 0)
                
                withAnimation(animate ? defaultAnimation : noAnimation) {
                    self.angle += closestAngle.degrees
                }
            }
        }
    }
}

#Preview {
    RadialMenuView()
}
 */
