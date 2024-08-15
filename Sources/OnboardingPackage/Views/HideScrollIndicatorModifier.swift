//
//  HideScrollIndicatorModifier.swift
//
//
//  Created by Div Khare on 8/15/24.
//

import Foundation
import SwiftUI

struct HideScrollIndicatorModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
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
    func hideScrollIndicator(_ isHidden: Bool) -> some View {
        self.modifier(HideScrollIndicatorModifier(isHidden: isHidden))
    }
}
