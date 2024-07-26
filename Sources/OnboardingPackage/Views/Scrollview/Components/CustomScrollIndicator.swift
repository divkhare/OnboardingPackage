//
//  CustomScrollIndicator.swift
//
//
//  Created by Div Khare on 7/26/24.
//

import SwiftUI

public struct CustomScrollIndicator: View {
    @Binding var currentPage: Int
    var numberOfPages: Int

    public var body: some View {
        HStack {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue.opacity(0.8) : Color.gray.opacity(0.5))
                    .frame(width: 10, height: 10)
                    .scaleEffect(index == currentPage ? 1.5 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: currentPage)
            }
        }
    }
}

struct CustomScrollIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CustomScrollIndicator(currentPage: .constant(0), numberOfPages: 5)
    }
}
