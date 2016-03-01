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
    let gravity             : Double = 9.81
    var updateTimeInterval  : Double
    var total_pos           : [Double] = [0, 0, 0]
    
    /// Only a single instance of CMMotionManager
    /// in all your app
    var motionManager       = CMMotionManager()
    
    init(updateTimeInterval: Double = 0.01) {
        self.updateTimeInterval = updateTimeInterval
    }
    
    deinit {
        if motionManager.deviceMotionActive {
            stopSensorsUpdate()
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
            if(self.motionManager.deviceMotion?.timestamp != nil) {
                usAccMetSecSQ[0] = ((motionManager.accelerometerData?.acceleration.x)! * gravity)
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
    
    
    
    
    /*
     __  __
    |  \/  | __ _  __ _
    | |\/| |/ _` |/ _` |
    | |  | | (_| | (_| |
    |_|  |_|\__,_|\__, |
                  |___/

    */
    
    
    
    
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
            if(self.motionManager.deviceMotion?.timestamp != nil) {
                usAccMetSecSQ[0] = ((motionManager.deviceMotion?.userAcceleration.x)! * gravity)
                usAccMetSecSQ[1] = ((motionManager.deviceMotion?.userAcceleration.y)! * gravity)
                usAccMetSecSQ[2] = ((motionManager.deviceMotion?.userAcceleration.z)! * gravity)
            }
            return usAccMetSecSQ
        }
    }
    
    var rotationRate: [Double] { // [m/s^2]
        get {
            var usAccMetSecSQ: [Double] = [0, 0, 0]
            if(self.motionManager.deviceMotion?.timestamp != nil) {
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