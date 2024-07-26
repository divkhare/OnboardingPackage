//
//  MotionManager.swift
//
//
//  Created by Div Khare on 7/25/24.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0

    func startMonitoringMotionUpdates() {
        guard self.motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }

        self.motionManager.deviceMotionUpdateInterval = 0.01
        
        self.motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
        }
    }
    
    func stopMonitoringMotionUpdates() {
        self.motionManager.stopDeviceMotionUpdates()
    }
}
