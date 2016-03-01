//
//  CoreMotionWriter.swift
//  CoreMotionDataExtractor
//
//  Created by Amedeo Setti on 01/03/16.
//  Copyright © 2016 Amedeo Setti. All rights reserved.
//

import Foundation

class CoreMotionStreamType {
    var key     : String
    var file    : String
    var stream  : NSOutputStream?
    
    init(key: String, file: String, stream: NSOutputStream?) {
        self.key    = key
        self.file   = file
        self.stream = stream
    }
    
    deinit {
        
    }
}

class CoreMotionWriter
{
    let accelerationFile = "acceleration.csv"
    let deviceMotionFile = "deviceMotion.csv"
    let gyroscopeFile    = "gyroscope.csv"
    
    var accelerationStream : NSOutputStream?
    var deviceMotionStream : NSOutputStream?
    var gryoscopeStream    : NSOutputStream?
    

    
    lazy var coreMotionStreams = [CoreMotionStreamType]()
    
    
    init() {
        coreMotionStreams.append(CoreMotionStreamType(key: "acceleration",  file: "acceleration.csv",   stream: nil))
        coreMotionStreams.append(CoreMotionStreamType(key: "deviceMotion",  file: "deviceMotion.csv",   stream: nil))
        coreMotionStreams.append(CoreMotionStreamType(key: "gyroscope",     file: "gyroscope.csv",      stream: nil))
        coreMotionStreams.append(CoreMotionStreamType(key: "rotMatrix",     file: "rotMatrix.csv",      stream: nil))
        coreMotionStreams.append(CoreMotionStreamType(key: "quaternions",   file: "quaternions.csv",    stream: nil))
    }
    
    deinit {
        
    }
    
    /*
     Acceleration
    */
    
    func openAccelerationStream() {
        openStream("acceleration")
        writeToStream("acceleration", content: "accX, accY, accZ, \n")
    }
    
    func writeAcceleration(acceleration: [Double]) {
        let content = String(acceleration[0]) + "," +
                        String(acceleration[1]) + "," +
                            String(acceleration[2]) + "," + "\n"
        writeToStream("acceleration", content: content)
    }
    
    func closeAccelerationStream() {
        closeStream("acceleration")
    }
    
    func removePreviusAccelerationStream() {
        removeStream("acceleration")
    }
    
    /*
     Gryo
    */
    
    func openGyroscopeStream() {
        openStream("gyroscope")
        writeToStream("gyroscope", content: "rawRotRateX, rawRotRateY, rawRoteRateZ, \n")
    }
    
    func writeGyroscope(rotationRate: [Double]) {
        let content = String(rotationRate[0]) + "," +
                        String(rotationRate[1]) + "," +
                            String(rotationRate[2]) + "," + "\n"
        writeToStream("gyroscope", content: content)
    }
    
    func closeGyroscopeStream() {
        closeStream("gyroscope")
    }
    
    func removePreviusGyroscopeStream() {
        removeStream("gyroscope")
    }
    
    /*
     Device Motion
    */
    func openDeviceMotionStream() {
        openStream("deviceMotion")
        writeToStream("deviceMotion", content: "accX, accY, accZ, rotRateX, rotRateY, rotRateZ \n")
    }
    
    func writeDeviceMotion(deviceMotion: [[Double]]) {
        let content = String(deviceMotion[0][0]) + "," +
                        String(deviceMotion[0][1]) + "," +
                            String(deviceMotion[0][2]) + "," +
                                String(deviceMotion[1][0]) + "," +
                                    String(deviceMotion[1][1]) + "," +
                                        String(deviceMotion[1][2]) + "," + "\n"
        writeToStream("deviceMotion", content: content)
    }
    
    func closeDeviceMotionStream() {
        closeStream("deviceMotion")
    }
    
    func removePreviusDeviceMotionStream() {
        removeStream("deviceMotion")
    }
    
    /*
     Attitude
    */
    func openAttitudeStream() {
        openStream("rotMatrix")
        writeToStream("rotMatrix", content: "m11, m12, m13, m21, m22, m23, m31, m32, m33 \n")
        
        openStream("quaternions")
        writeToStream("quaternions", content: "w, x, y, z \n")
    }
    
    func writeAttitude(rotMatrix: [Double], quaternions: [Double]) {
        let rM = String(rotMatrix[0]) + "," +
                    String(rotMatrix[1]) + "," +
                        String(rotMatrix[2]) + "," +
                            String(rotMatrix[3]) + "," +
                                String(rotMatrix[4]) + "," +
                                    String(rotMatrix[5]) + "," +
                                        String(rotMatrix[6]) + "," +
                                            String(rotMatrix[7]) + "," +
                                                String(rotMatrix[8]) + "," + "\n"
        writeToStream("rotMatrix", content: rM)

        let quat = String(quaternions[0]) + "," +
                    String(quaternions[1]) + "," +
                        String(quaternions[2]) + "," +
                            String(quaternions[3]) + "," + "\n"
        writeToStream("quaternions", content: quat)
    }
    
    func closeAttitudeStream() {
        closeStream("rotMatrix")
        closeStream("quaternions")
    }
    
    func removePreviusAttitudeStream() {
        removeStream("rotMatrix")
        removeStream("quaternions")
    }
    
    /*
     Generic Open and Close stream
    */
    
    private func openStream(key: String) {
        let cmdata = getCoreMotionStreamForKey(key)
        if cmdata == nil {
            return
        }
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileName: String = documentsDirectory + "/" + (cmdata?.file)!
        cmdata?.stream = NSOutputStream(toFileAtPath: fileName, append: true)
        if cmdata?.stream != nil {
            cmdata?.stream!.open()
        }
    }
    
    private func closeStream(key: String) {
        let cmdata = getCoreMotionStreamForKey(key)
        if cmdata == nil {
            return
        }
        if cmdata?.stream != nil {
            cmdata?.stream!.close()
        }
    }
    
    private func writeToStream(key: String, content: String) {
        let cmdata = getCoreMotionStreamForKey(key)
        if cmdata == nil {
            return
        }
        if cmdata?.stream != nil {
            cmdata?.stream!.write(content)
        }
    }
    
    private func removeStream(key: String) {
        let cmdata = getCoreMotionStreamForKey(key)
        if cmdata == nil {
            return
        }
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileToRemove: String = documentsDirectory + "/" + (cmdata?.file)!

        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(fileToRemove)
        }
        catch let error as NSError {
            print("\(self) impossible to remove file: \(error)")
        }
    }
    
    private func getCoreMotionStreamForKey(key: String) -> CoreMotionStreamType? {
        for k in coreMotionStreams {
            if k.key == key {
                return k
            }
        }
        return nil
    }
    
}
















