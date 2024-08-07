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

class PermissionsManager: ObservableObject {
    static let shared = PermissionsManager()
    
    @Published var micPermissionGranted: Bool = false
    @Published var notificationsPermissionGranted: Bool = false
    @Published var cameraPermissionGranted: Bool = false
    
    private init() {
        Task { @MainActor in
            self.micPermissionGranted = await checkMicrophonePermissionStatus()
            self.notificationsPermissionGranted = await checkPushNotificationPermissionStatus()
            self.cameraPermissionGranted = await checkCameraPermissionStatus()
        }
    }

    // MARK: - Remote Push Notifications
    func requestPushNotificationPermission() async {
        let granted = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                continuation.resume(returning: granted)
            }
        }
        DispatchQueue.main.async {
            self.notificationsPermissionGranted = granted
        }
    }

    // MARK: - Microphone Permissions
    func requestMicrophonePermission() async {
        let granted = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        DispatchQueue.main.async {
            self.micPermissionGranted = granted
        }
    }

    // MARK: - Camera Permissions
    func requestCameraPermission() async {
        let granted = await withCheckedContinuation { continuation in
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
        DispatchQueue.main.async {
            self.cameraPermissionGranted = granted
        }
    }
    
    // MARK: - Check Permissions Status
    func checkPushNotificationPermissionStatus() async -> Bool {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func checkMicrophonePermissionStatus() async -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    func checkCameraPermissionStatus() async -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
}
