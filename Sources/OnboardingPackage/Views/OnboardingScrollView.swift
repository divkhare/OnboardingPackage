//
//  ParallaxPageView.swift
//
//
//  Created by Div Khare on 7/25/24.
//

import SwiftUI

private enum Constants {
    static let backgroundImageHeightOffset: CGFloat = 500
    static let backgroundImageWidthOffset: CGFloat = 200
    static let backgroundImageParallaxOffset: CGFloat = 1.5
}

public struct OnboardingScrollView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var stateManager = StateManager()

    private var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        GeometryReader { globalGeometry in
            ScrollViewReader { value in
                ZStack(alignment: .bottom) {
                    PagingScrollView(currentPage: $stateManager.currentPage, pageCount: configuration.views.count) {
                        ZStack(alignment: .center) {
                            backgroundImage
                            HStack(spacing: 0) {
                                ForEach(configuration.views.indices, id: \.self) { index in
                                    configuration.views[index]
                                        .frame(width: globalGeometry.size.width)
                                }
                            }
                        }
                        .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                    CustomScrollIndicator(currentPage: $stateManager.currentPage, numberOfPages: configuration.views.count)
                    .padding(.bottom, 20)
                }

            }
        }
    }

    private var backgroundImage: some View {
        GeometryReader { scrollGeometry in
            Image("backgroundImage", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: CGFloat(configuration.views.count) * Constants.backgroundImageWidthOffset,
                       height: scrollGeometry.frame(in: .global).height + Constants.backgroundImageHeightOffset)
                .offset(x: -scrollGeometry.frame(in: .global).minX / Constants.backgroundImageParallaxOffset)
        }
    }
}


#Preview(body: {
    OnboardingScrollView(configuration: Configuration(
        views: [
            AnyView(WelcomeView()),
            AnyView(PermissionRequestView(permissions: [.notifications, .mic, .camera])),
            AnyView(PhoneNumberVerificationView()),
            AnyView(Text("Discover new features!")),
            AnyView(Text("Discover new features!")),
            AnyView(Text("Let's get started!")),
            AnyView(Text("Let's get started!"))
         ]
     ))
})

