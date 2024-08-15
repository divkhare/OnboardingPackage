//
//  HideScrollIndicatorModifier.swift
//
//
//  Created by Div Khare on 8/15/24.
//

import Foundation
import SwiftUI

public struct HideScrollIndicatorModifier: ViewModifier {
    let isHidden: Bool
    
    public func body(content: Content) -> some View {
        content
            .preference(key: ScrollIndicatorVisibilityKey.self, value: !isHidden)
    }
}

struct ScrollIndicatorVisibilityKey: PreferenceKey {
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    public func hideScrollIndicator(_ isHidden: Bool) -> some View {
        self.modifier(HideScrollIndicatorModifier(isHidden: isHidden))
    }
}
