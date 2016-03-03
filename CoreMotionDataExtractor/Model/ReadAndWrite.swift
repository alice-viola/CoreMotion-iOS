//
//  ReadAndWrite.swift
//  CoreMotionDataExtractor
//
//  Created by Amedeo Setti on 01/03/16.
//  Copyright © 2016 Amedeo Setti. All rights reserved.
//

import Foundation

class ReadAndWriteFile
{
    class func writeToFile(file: String, content: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileName: String = documentsDirectory + "/" + file
        do {
            try content.writeToFile(fileName, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print("\(self): error in write to file")
        }
    }
    
    class func appendToFile(file: String, content: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileName: String = documentsDirectory + "/" + file
        
        if let outputStream = NSOutputStream(toFileAtPath: fileName, append: true) {
            outputStream.open()
            outputStream.write(content + "\n")
            outputStream.close()
        } else {
            print("\(self): unable to open file")
        }
    }
    
    class func getFile(file: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileName: String = documentsDirectory + "/"  + file
        let content: String
        do {
            content = try String(contentsOfFile: fileName, encoding: NSUTF8StringEncoding)
            return content
        } catch {
            print("\(self): error in get the file")
            return nil
        }
    }
    
    class func getFilePath(file: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileName: String = documentsDirectory + "/"  + file
        return fileName
    }
}

// Thanks to Rob of SO +1
extension NSOutputStream {
    
    /// Write String to outputStream
    ///
    /// - parameter string:                The string to write.
    /// - parameter encoding:              The NSStringEncoding to use when writing the string. This will default to UTF8.
    /// - parameter allowLossyConversion:  Whether to permit lossy conversion when writing the string.
    ///
    /// - returns:                         Return total number of bytes written upon success. Return -1 upon failure.
    
    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int {
        if let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0
            
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}