//
//  Configuration.swift
//  
//
//  Created by Div Khare on 7/26/24.
//

import Foundation
import SwiftUI

public struct PermissionConfiguration {
    /// Types of permissions to be requested
    var permissions: [PermissionType]
}

/// Types of permissions
public enum PermissionType {
    case mic
    case notifications
    case camera
    case contacts
    case ads

    var displayName: String {
        switch self {
        case .mic:
            return "Microphone"
        case .notifications:
            return "Notifications"
        case .camera:
            return "Camera"
        case .contacts:
            return "Contacts"
        case .ads:
            return "Advertisements"
        }
    }

    var displayText: String {
        switch self {
        case .mic:
            return "Grant microphone access so you can speak your journals out loud. Rest assured, we don't store any audio data."
        case .notifications:
            return "Receive gentle reminders to jot down your experiences. If you're connected with a therapist, we'll help you stay in touch."
        case .camera:
            return "Snap a picture and instantly transform it into a journal entry. It's quick and hassle-free!"
        case .contacts:
            return "Share entries and receive support from your loved ones. Your connections are just a permission away!"
        case .ads:
            return "Help us tailor the app to your interests by allowing personalized ads."
        }
    }

    var displayImage: Image {
        switch self {
        case .mic:
            return Image(systemName: "waveform.badge.mic")
        case .notifications:
            return Image(systemName: "message.badge.waveform.fill")
        case .camera:
            return Image(systemName: "camera.fill")
        case .contacts:
            return Image(systemName: "book.closed.fill")
        case .ads:
            return Image(systemName: "tv.inset.filled")
        }
    }
}
