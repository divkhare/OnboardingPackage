//
//  PagingScrollView.swift
//
//
//  Created by Div Khare on 7/26/24.
//

import Foundation
import SwiftUI

struct PagingScrollView<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var currentPage: Int
    let pageCount: Int

    init(currentPage: Binding<Int>, pageCount: Int, @ViewBuilder content: () -> Content) {
        self._currentPage = currentPage
        self.pageCount = pageCount
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.subviews.first?.widthAnchor.constraint(equalTo: uiView.widthAnchor, multiplier: CGFloat(pageCount)).isActive = true
        uiView.contentSize = CGSize(width: uiView.frame.width * CGFloat(pageCount), height: uiView.bounds.height)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PagingScrollView

        init(_ parent: PagingScrollView) {
            self.parent = parent
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            parent.currentPage = page
        }
    }
}
