//
//  ViewController.swift
//  CoreMotionDataExtractor
//
//  Created by Amedeo Setti on 01/03/16.
//  Copyright © 2016 Amedeo Setti. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    lazy var deviceMotionTestCase = AccelerometerTest()
    var updateTimer               = NSTimer()

    /// Hz
    let preferredUpdateFrequency: Double = 10.0
    var updateTime: NSTimeInterval {
        get {
            return preferredUpdateFrequency / 60.0
        }
    }
    
    @IBOutlet var accView               : UIView!
    @IBOutlet var gyroView              : UIView!
    @IBOutlet var magView               : UIView!
    @IBOutlet var devMotView            : UIView!
    @IBOutlet var startStopBut          : UIButton!
    
    @IBOutlet var getAccelerationSwitch : UISwitch!
    @IBOutlet var getGryscopeSwitch     : UISwitch!
    @IBOutlet var getDeviceMotionSwitch : UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAspect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAspect() {
        self.accView.layer.cornerRadius      = 5
        self.gyroView.layer.cornerRadius     = 5
        self.magView.layer.cornerRadius      = 5
        self.devMotView.layer.cornerRadius   = 5
        self.startStopBut.layer.cornerRadius = 5
    }
    

    dynamic func updateTimerSelector() {
        if getAccelerationSwitch.on {
            print(self.deviceMotionTestCase.getAccelerometerData())
        }
        
        if getGryscopeSwitch.on {
            
        }
        
        if getDeviceMotionSwitch.on {
            print(self.deviceMotionTestCase.getDeviceMotionData())
        }
    }
    
    func startSensorsAcquisition() {
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(
            updateTime,
            target: self,
            selector: "updateTimerSelector",
            userInfo: nil,
            repeats: true)
        
        if getAccelerationSwitch.on {
            self.deviceMotionTestCase.stopAccelerometerUpdate()
        }
        
        if getGryscopeSwitch.on {
            
        }
        
        if getDeviceMotionSwitch.on {
            self.deviceMotionTestCase.startDeviceMotionUpdate()
        }

    }
    
    func stopSensorsAcquisition() {
        self.updateTimer.invalidate()
        
        if getAccelerationSwitch.on {
            self.deviceMotionTestCase.stopAccelerometerUpdate()
        }
        
        if getGryscopeSwitch.on {
            
        }
        
        if getDeviceMotionSwitch.on {
            self.deviceMotionTestCase.stopDeviceMotionUpdate()
        }
    }
    
    /*
     ___ ____    _        _   _
    |_ _| __ )  / \   ___| |_(_) ___  _ __  ___
     | ||  _ \ / _ \ / __| __| |/ _ \| '_ \/ __|
     | || |_) / ___ \ (__| |_| | (_) | | | \__ \
    |___|____/_/   \_\___|\__|_|\___/|_| |_|___/
    
    */
    
    @IBAction func wantsAcceleration(sender: AnyObject) {
        
    }
    
    @IBAction func wantsGryoscope(sender: AnyObject) {
    
    }
    
    @IBAction func wantsMagnetometer(sender: AnyObject) {
        let alert = UIAlertController(title: self.title,
            message: "Function is not implemented yet",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        (sender as! UISwitch).on = false
    }
    
    @IBAction func wantsDeviceMotion(sender: AnyObject) {
    
    }
    
    @IBAction func startStopAction(sender: AnyObject) {
        if (sender as! UIButton).currentTitle == "Stop" {
            self.stopSensorsAcquisition()
            (sender as! UIButton).setTitle("Start", forState: UIControlState.Normal)
        } else {
            self.startSensorsAcquisition()
            (sender as! UIButton).setTitle("Stop", forState: UIControlState.Normal)
        }
    }
    

}

