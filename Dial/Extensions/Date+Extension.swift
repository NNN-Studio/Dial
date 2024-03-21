//
//  Date+Extension.swift
//  Dial
//
//  Created by KrLite on 2024/3/21.
//

import Foundation

extension Date {
    func timeIntervalSince(
        _ date: Date?
    ) -> TimeInterval? {
        if let date {
            return timeIntervalSince(date)
        } else {
            return nil
        }
    }
}
