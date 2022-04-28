//
//  ConditionClassifier.swift
//  Weather-App
//
//  Created by Erik Egers on 2022/04/25.
//

import Foundation

struct ConditionClassifier {
    static func classifyCondition(by: Int) -> Condition {
        switch by {
        case ConditionRanges.rainRange:
            return .rainy
        case ConditionRanges.cloudyRange:
            return .cloudy
        default:
            return .sunny
        }
    }
}

enum ConditionRanges {
    static let rainRange = 200...799
    static let cloudyRange = 801...899
    case sunnyRange
}

enum Condition: String {
    case sunny
    case cloudy
    case rainy
}
