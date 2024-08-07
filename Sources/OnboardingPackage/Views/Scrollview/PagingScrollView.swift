//
//  PagingScrollView.swift
//
//
//  Created by Div Khare on 7/26/24.
//

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
        let scrollView = KeyboardAwareScrollView()
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

class KeyboardAwareScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboardObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        UIView.animate(withDuration: 0.3) {
            self.contentInset.bottom = keyboardHeight
            self.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentInset.bottom = 0
            self.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
