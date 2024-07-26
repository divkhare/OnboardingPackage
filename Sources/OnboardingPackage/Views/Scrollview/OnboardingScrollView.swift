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
    @State private var currentPage: Int = 0
    
    private var numberOfScreens: Int = 0
    private let content: Content
    
    init(numberOfScreens: Int = 0, @ViewBuilder content: () -> Content) {
        self.numberOfScreens = numberOfScreens
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { globalGeometry in
            ScrollViewReader { value in
                ZStack(alignment: .bottom) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack(alignment: .center) {
                            backgroundImage
                            content
                        }
                        .background(GeometryReader {
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: -$0.frame(in: .global).minX)
                        })
                        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                            let pageWidth = globalGeometry.size.width
                            currentPage = Int(round(value / pageWidth))
                        }
                    }
                    VStack {
                        HStack {
                            Spacer()
                            nextPage(value: value, pageWidth: globalGeometry.size.width)
                        }
                        CustomScrollIndicator(currentPage: $currentPage, numberOfPages: numberOfScreens)
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    UIScrollView.appearance().isPagingEnabled = true
                }
                .ignoresSafeArea()
            }
        }
    }

    private var backgroundImage: some View {
        GeometryReader { scrollGeometry in
            Image("backgroundImage", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: CGFloat(numberOfScreens) * Constants.backgroundImageWidthOffset,
                       height: scrollGeometry.frame(in: .global).height + Constants.backgroundImageHeightOffset)
                .offset(x: -scrollGeometry.frame(in: .global).minX / Constants.backgroundImageParallaxOffset)
        }
    }

    private func nextPage(value: ScrollViewProxy, pageWidth: CGFloat) -> some View {
        Button(action: {
            withAnimation {
                let nextPage = min(currentPage + 1, numberOfScreens - 1)
                value.scrollTo(nextPage, anchor: .center)
                currentPage = nextPage
            }
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .opacity(0.5)
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(.white)
            .padding(.trailing)
        })
    }
}

struct HorizontalParallaxScrollView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScrollView(numberOfScreens: 10, content: {
            HStack {
                ForEach(0..<10, id: \.self) { index in
                    VStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        Text("Item \(index)")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                    }
                }
            }
        })
    }
}
