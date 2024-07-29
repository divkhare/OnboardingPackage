//
//  File.swift
//  
//
//  Created by Div Khare on 7/25/24.
//

import Foundation
import SwiftUI

public struct OnboardingStep {
    let title: String
    let content: AnyView

    public init(title: String, content: AnyView) {
        self.title = title
        self.content = content
    }
}
