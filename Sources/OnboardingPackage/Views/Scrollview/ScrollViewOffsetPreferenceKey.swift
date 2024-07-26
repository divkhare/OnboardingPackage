//
//  ScrollViewOffsetPreferenceKey.swift
//
//
//  Created by Div Khare on 7/26/24.
//

import Foundation
import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
