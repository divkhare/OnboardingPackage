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

public struct OnboardingScrollView<Content: View>: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var stateManager = OnboardingStateManager.shared

    private let content: Content
    private let pageCount: Int
    
    public init(pageCount: Int, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.pageCount = pageCount
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottom) {
                PagingScrollView(currentPage: $stateManager.currentPage, pageCount: pageCount) {
                    ZStack {
                        backgroundImage
                        content
                            .id(stateManager.currentPage) // Add ID here
                            .environmentObject(stateManager)
                    }
                    .ignoresSafeArea()
                }
                .ignoresSafeArea()
                CustomScrollIndicator(currentPage: $stateManager.currentPage, numberOfPages: pageCount)
            }
            .onChange(of: stateManager.verifiedPhone) { newValue in
                guard let _ = newValue else { return }
                if stateManager.currentPage < pageCount - 1 {
                    withAnimation {
                        stateManager.currentPage += 1
                        proxy.scrollTo(stateManager.currentPage, anchor: .center)
                    }
                }
            }
        }
        .environment(\.currentPage, stateManager.currentPage)
    }

    private var backgroundImage: some View {
        GeometryReader { scrollGeometry in
            Image("backgroundImage", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: CGFloat(pageCount) * Constants.backgroundImageWidthOffset,
                       height: scrollGeometry.frame(in: .global).height + Constants.backgroundImageHeightOffset)
                .offset(x: -scrollGeometry.frame(in: .global).minX / Constants.backgroundImageParallaxOffset)
        }
    }
}

#Preview {
    @StateObject var stateManager = OnboardingStateManager.shared

    return OnboardingScrollView(pageCount: 4) {
        HStack(spacing: 0) {
            WelcomeView(thisViewIndex: 0)
            PermissionRequestView(permissions: [.notifications, .mic, .camera], thisViewIndex: 1)
            RegisterNewUserView(viewModel: RegisterNewUserViewModel(signupCallback: { info in
                print(info)
            }), thisViewIndex: 2)
            PhoneNumberVerificationView(viewModel: PhoneVerificationViewModel(), thisViewIndex: 3) {
                print("Phone number verified successfully!")
                // Add any additional logic you want to execute on verification success
            }
        }
    }
    .environmentObject(stateManager)
}
