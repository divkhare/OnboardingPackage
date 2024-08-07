//
//  StateManager.swift
//  
//
//  Created by Div Khare on 7/26/24.
//

import Foundation
import UIKit

public class OnboardingStateManager: ObservableObject {
    public static let shared = OnboardingStateManager()
    @Published public var verifiedPhone: String?

    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }

    @Published var currentPage: Int {
        didSet {
            UserDefaults.standard.set(currentPage, forKey: "onboardingCurrentPage")
        }
    }

    private init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.currentPage = UserDefaults.standard.integer(forKey: "onboardingCurrentPage")
    }
    
    public func completeOnboarding() {
        self.hasCompletedOnboarding = true
        self.currentPage = 0
    }
}
