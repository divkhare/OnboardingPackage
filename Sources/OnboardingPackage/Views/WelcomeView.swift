//
//  File.swift
//  
//
//  Created by Div Khare on 7/25/24.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0

    let onboardingPages = [
        OnboardingPage(title: "Welcome", description: "Welcome to our app. We're glad to have you!", body: "some body", imageName: "figure.basketball"),
        OnboardingPage(title: "Discover", description: "Discover new features and stay updated.", body: "some body", imageName: "figure.basketball"),
        OnboardingPage(title: "Get Started", description: "Let's get started with setting up your profile.", body: "some body", imageName: "figure.run.circle.fill")
    ]

    var body: some View {
        ScrollView(.horizontal) {
//            GeometryReader { pageGeometry in
//                Image(systemName: "figure.run.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                    .offset(x: -pageGeometry.frame(in: .global).minX / 2)
//            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

