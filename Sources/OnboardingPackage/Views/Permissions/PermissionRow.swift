//
//  PermissionRow.swift
//
//
//  Created by Div Khare on 7/28/24.
//

import Foundation
import SwiftUI

struct PermissionRow: View {
    let permission: PermissionType
    @ObservedObject var permissionManager = PermissionsManager.shared

    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await requestPermission(permission)
                }
               }) {
                   if isPermissionGranted(permission) {
                       Image(systemName: "checkmark.circle.fill")
                           .foregroundColor(.green)
                           .disabled(true)
                   } else {
                       HStack {
                           permission.displayImage
                               .resizable()
                               .scaledToFit()
                               .frame(width: 20, height: 20)
                               .padding([.leading], 5)
                           Text("Allow \(permission.displayName)")
                               .font(.callout).bold()
                               .multilineTextAlignment(.center)
                       }
                       .padding(.horizontal, 20)
                       .padding(.vertical, 10)
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
                   }
               }
            Text(permission.displayText)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .foregroundStyle(.white) // Change this to see text in preview
                .padding(10)
        }
    }
    
    private func requestPermission(_ type: PermissionType) async {
        switch type {
        case .mic:
            await permissionManager.requestMicrophonePermission()
        case .notifications:
            await permissionManager.requestPushNotificationPermission()
        case .camera:
            await permissionManager.requestCameraPermission()
        case .contacts, .ads:
            break
        }
    }
    
    private func isPermissionGranted(_ type: PermissionType) -> Bool {
        switch type {
        case .mic:
            return permissionManager.micPermissionGranted
        case .notifications:
            return permissionManager.notificationsPermissionGranted
        case .camera:
            return permissionManager.cameraPermissionGranted
        case .contacts, .ads:
            return false
        }
    }
}

#Preview {
    Group {
        PermissionRow(permission: .ads)
        PermissionRow(permission: .mic)
        PermissionRow(permission: .camera)
        PermissionRow(permission: .notifications)
        PermissionRow(permission: .contacts)
    }
}
