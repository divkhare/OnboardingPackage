//
//  PermissionsManager.swift
//
//
//  Created by Div Khare on 7/26/24.
//

import Foundation
import UserNotifications
import AVFoundation
import UIKit

class PermissionsManager {
    static let shared = PermissionsManager()
    private init() {}

    // MARK: - Remote Push Notifications
    func requestPushNotificationPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                continuation.resume(returning: granted)
            }
        }
    }

    // MARK: - Microphone Permissions
    func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    // MARK: - Camera Permissions
    func requestCameraPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                continuation.resume(returning: true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            case .denied, .restricted:
                continuation.resume(returning: false)
            @unknown default:
                continuation.resume(returning: false)
            }
        }
    }
    
    // MARK: - Check Permissions Status
    
    func checkPushNotificationPermissionStatus() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func checkMicrophonePermissionStatus() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    func checkCameraPermissionStatus() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
}
