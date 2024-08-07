//
//  PermissionRequestView.swift
//
//
//  Created by Div Khare on 7/28/24.
//

import Foundation
import SwiftUI

public struct PermissionRequestView: View {
    @ObservedObject private var permissionManager = PermissionsManager.shared
    let permissions: [PermissionType]
    @State private var animateGradient = false
    private let thisViewIndex: Int

    public init?(permissions: [PermissionType], thisViewIndex: Int) {
        guard permissions.count <= 4 else {
            print("Exceeded maximum permissions allowed")
            return nil
        }
        self.permissions = permissions
        self.thisViewIndex = thisViewIndex
    }

    public var body: some View {
        VStack {
            Text("Just a Few Quick Favors!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            VStack {
                ForEach(permissions, id: \.self) { permission in
                    PermissionRow(permission: permission)
                        .padding(.top)
                }
            }
            .background(.black.opacity(0.2))
            .cornerRadius(10)
            .padding([.trailing, .leading])
            Button(action: openSettings, label: {
                HStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding([.leading], 5)
                    Text("Open Settings")
                        .font(.callout).bold()
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 30)
            })
        }
        
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    OnboardingScrollView(pageCount: 4) {
        HStack(spacing: 0) {
            WelcomeView(thisViewIndex: 0)
            PermissionRequestView(permissions: [.notifications, .mic, .camera], thisViewIndex: 1)
            RegisterNewUserView(viewModel: RegisterNewUserViewModel(signupCallback: { info in
                print(info)
            }), thisViewIndex: 2)
            PhoneNumberVerificationView(viewModel: PhoneVerificationViewModel(), thisViewIndex: 3)
        }
    }
}
