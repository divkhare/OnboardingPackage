//
//  CurrentPageKey.swift
//
//
//  Created by Div Khare on 8/2/24.
//

import Foundation
import SwiftUI

private struct CurrentPageKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    var currentPage: Int {
        get { self[CurrentPageKey.self] }
        set { self[CurrentPageKey.self] = newValue }
    }
}
