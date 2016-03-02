//
//  Accelerometer.swift
//  CoreMotionDataExtractor
//
//  Created by Amedeo Setti on 01/03/16.
//  Copyright © 2016 Amedeo Setti. All rights reserved.
//

import Foundation
import CoreMotion

protocol DeviceMotionFunctions
{
    func startSensorsUpdate() -> Bool
    func stopSensorsUpdate()
    func getDeviceMotionData() -> [[Double]]
}

class DeviceMotionUtility: DeviceMotionFunctions
{
    let gravity             : Double    = 9.81
    var updateTimeInterval  : Double
    
    /// Use ONLY ONE single instance of CMMotionManager
    /// in all your app
    var motionManager       = CMMotionManager()
    
    init(updateTimeInterval: Double = 0.01) {
        self.updateTimeInterval = updateTimeInterval
    }
    
    deinit {
        if motionManager.deviceMotionActive {
            stopSensorsUpdate()
        }
        if motionManager.accelerometerActive {
            stopAccelerometerUpdate()
        }
        if motionManager.gyroActive {
            stopGyroscopeUpdate()
        }
    }
    
    /*
        _                _                _   _
       / \   ___ ___ ___| | ___ _ __ __ _| |_(_) ___  _ __
      / _ \ / __/ __/ _ \ |/ _ \ '__/ _` | __| |/ _ \| '_ \
     / ___ \ (_| (_|  __/ |  __/ | | (_| | |_| | (_) | | | |
    /_/   \_\___\___\___|_|\___|_|  \__,_|\__|_|\___/|_| |_|
    
    */
    var acc: [Double] { // [m/s^2]
        get {
            var usAccMetSecSQ: [Double] = [0, 0, 0]
            if let x = (motionManager.accelerometerData?.acceleration.x) {
                usAccMetSecSQ[0] = (x * gravity)
                usAccMetSecSQ[1] = ((motionManager.accelerometerData?.acceleration.y)! * gravity)
                usAccMetSecSQ[2] = ((motionManager.accelerometerData?.acceleration.z)! * gravity)
            }
            return usAccMetSecSQ
        }
    }
    
    func startAccelerometerUpdate() -> Bool {
        while !motionManager.accelerometerAvailable {
            // Wait
        }
        startAccelerometerUpdatePull()
        return true
    }
    
    private func startAccelerometerUpdatePull() {
        motionManager.accelerometerUpdateInterval = updateTimeInterval
        motionManager.startAccelerometerUpdates()
    }
    
    func stopAccelerometerUpdate() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func getAccelerometerData() -> [Double] {
        return self.acc
    }

    
    /*
      ____
     / ___|_ __ _   _  ___
    | |  _| '__| | | |/ _ \
    | |_| | |  | |_| | (_) |
     \____|_|   \__, |\___/
                |___/

    */
    var gryo: [Double] { // [rad/s]
        get {
            var rotRate: [Double] = [0, 0, 0]
            if let x = (motionManager.gyroData?.rotationRate.x) {
                rotRate[0] = x
                rotRate[1] = ((motionManager.gyroData?.rotationRate.y)!)
                rotRate[2] = ((motionManager.gyroData?.rotationRate.z)!)
            }
            return rotRate
        }
    }
    
    func startGyroscopeUpdate() -> Bool {
        while !motionManager.gyroAvailable{
            // Wait
        }
        startGyroscopeUpdatePull()
        return true
    }
    
    private func startGyroscopeUpdatePull() {
        motionManager.gyroUpdateInterval = updateTimeInterval
        motionManager.startGyroUpdates()
    }
    
    func stopGyroscopeUpdate() {
        motionManager.stopGyroUpdates()
    }
    
    func getGyroscopeData() -> [Double] {
        return self.gryo
    }
    
    
    /*
     ____             _          __  __       _   _
    |  _ \  _____   _(_) ___ ___|  \/  | ___ | |_(_) ___  _ __
    | | | |/ _ \ \ / / |/ __/ _ \ |\/| |/ _ \| __| |/ _ \| '_ \
    | |_| |  __/\ V /| | (_|  __/ |  | | (_) | |_| | (_) | | | |
    |____/ \___| \_/ |_|\___\___|_|  |_|\___/ \__|_|\___/|_| |_|
    
    */
    
    var devMotAcc: [Double] { // [m/s^2]
        get {
            var usAccMetSecSQ: [Double] = [0, 0, 0]
            if (self.motionManager.deviceMotion?.timestamp != nil) {
                usAccMetSecSQ[0] = ((motionManager.deviceMotion?.userAcceleration.x)! * gravity)
                usAccMetSecSQ[1] = ((motionManager.deviceMotion?.userAcceleration.y)! * gravity)
                usAccMetSecSQ[2] = ((motionManager.deviceMotion?.userAcceleration.z)! * gravity)
            }
            return usAccMetSecSQ
        }
    }
    
    var rotationRate: [Double] { // [rad/s]
        get {
            var usAccMetSecSQ: [Double] = [0, 0, 0]
            if (self.motionManager.deviceMotion?.timestamp != nil) {
                usAccMetSecSQ[0] = ((motionManager.deviceMotion?.rotationRate.x)! )
                usAccMetSecSQ[1] = ((motionManager.deviceMotion?.rotationRate.y)! )
                usAccMetSecSQ[2] = ((motionManager.deviceMotion?.rotationRate.z)! )
            }
            return usAccMetSecSQ
        }
    }
    
    var data: [[Double]] { // [m/s^2, rad/s]
        get {
            return [[Double]]([devMotAcc, rotationRate])
        }
    }
    
    var rotMatrix: [Double] {
        get {
            var rotMatrix: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            if (self.motionManager.deviceMotion?.timestamp != nil) {
                rotMatrix[0] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m11)!)
                rotMatrix[1] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m12)!)
                rotMatrix[2] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m13)!)
                
                rotMatrix[3] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m21)!)
                rotMatrix[4] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m22)!)
                rotMatrix[5] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m23)!)
                
                rotMatrix[6] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m31)!)
                rotMatrix[7] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m32)!)
                rotMatrix[8] = ((motionManager.deviceMotion?.attitude.rotationMatrix.m33)!)
            }
            return rotMatrix
        }
    }
    
    var quaternions: [Double] { // w, x, y, z
        get {
            var quat: [Double] = [0, 0, 0, 0]
            if (self.motionManager.deviceMotion?.timestamp != nil) {
                quat[0] = ((motionManager.deviceMotion?.attitude.quaternion.w)!)
                quat[1] = ((motionManager.deviceMotion?.attitude.quaternion.x)!)
                quat[2] = ((motionManager.deviceMotion?.attitude.quaternion.y)!)
                quat[3] = ((motionManager.deviceMotion?.attitude.quaternion.z)!)
            }
            return quat
        }
    }
    
    var eulerAngles: [Double] { // [rad]
        get {
            var eulers: [Double] = [0, 0, 0]
            if (self.motionManager.deviceMotion?.timestamp != nil) {
                eulers[0] = ((motionManager.deviceMotion?.rotationRate.x)!)
                eulers[1] = ((motionManager.deviceMotion?.rotationRate.y)!)
                eulers[2] = ((motionManager.deviceMotion?.rotationRate.z)!)
            }
            return eulers
        }
    }
    
    func startSensorsUpdate() -> Bool {
        while !motionManager.deviceMotionAvailable {
            // Wait
        }
        startDeviceMotionUpdatePull()
        return true
    }
    
    private func startDeviceMotionUpdatePull() {
        motionManager.deviceMotionUpdateInterval = updateTimeInterval
        motionManager.startDeviceMotionUpdates()
    }
    
    func stopSensorsUpdate() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func getDeviceMotionData() -> [[Double]] {
        return self.data
    }
}