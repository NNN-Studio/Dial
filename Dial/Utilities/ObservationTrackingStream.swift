//
//  ObservationTrackingStream.swift
//  Dial
//
//  Created by KrLite on 2024/3/23.
//

import Foundation

func observationTrackingStream<T>(
    _ apply: @escaping () -> T
) -> AsyncStream<T> {
    .init { continuation in
        @Sendable func observe() {
            let result = withObservationTracking {
                apply()
            } onChange: {
                DispatchQueue.main.async {
                    observe()
                }
            }
            
            continuation.yield(result)
        }
        
        observe()
    }
}
