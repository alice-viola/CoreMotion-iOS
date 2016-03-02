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
    lazy var writer               = CoreMotionWriter()
    var updateTimer               = NSTimer()
    private var isRunning         = false

    /// Hz
    var preferredUpdateFrequency: Double = 10.0
    /// Seconds
    var updateTime: NSTimeInterval {
        get {
            return 1.0 / preferredUpdateFrequency
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
    @IBOutlet var getAttitudeSwitch     : UISwitch!
    @IBOutlet var frequencyLabel        : UILabel!
    @IBOutlet var spinOutlet            : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAspect()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if getAccelerationSwitch.on {
            self.deviceMotionTestCase.stopAccelerometerUpdate()
        }
        
        if getGryscopeSwitch.on {
            self.deviceMotionTestCase.stopGyroscopeUpdate()
        }
        
        if getDeviceMotionSwitch.on {
            self.deviceMotionTestCase.startDeviceMotionUpdate()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
        self.spinOutlet.hidden               = true
    }
    

    dynamic func updateTimerSelector() {
        if getAccelerationSwitch.on {
            writer.writeAcceleration(self.deviceMotionTestCase.getAccelerometerData())
        }
        
        if getGryscopeSwitch.on {
            writer.writeGyroscope(self.deviceMotionTestCase.getGyroscopeData())
        }
        
        if getDeviceMotionSwitch.on {
            writer.writeDeviceMotion(self.deviceMotionTestCase.getDeviceMotionData())
        }
        
        if getAttitudeSwitch.on {
            writer.writeAttitude(self.deviceMotionTestCase.getAttitudeRotMatrix(),
                quaternions: self.deviceMotionTestCase.getAttitudeQuaternions(),
                eulers: self.deviceMotionTestCase.getEulerAngles())
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
            self.deviceMotionTestCase.startAccelerometerUpdate()
        }
        
        if getGryscopeSwitch.on {
            self.deviceMotionTestCase.startGyroscopeUpdate()
        }
        
        if getDeviceMotionSwitch.on || getAttitudeSwitch.on {
            self.deviceMotionTestCase.startDeviceMotionUpdate()
        }
    }
    
    func stopSensorsAcquisition() {
        self.updateTimer.invalidate()
        
        if getAccelerationSwitch.on {
            self.deviceMotionTestCase.stopAccelerometerUpdate()
        }
        
        if getGryscopeSwitch.on {
            self.deviceMotionTestCase.stopGyroscopeUpdate()
        }
        
        if getDeviceMotionSwitch.on || getAttitudeSwitch.on {
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
        if self.isRunning {
            (sender as! UISwitch).on = !(sender as! UISwitch).on
            presentAlertForNotAllowedSwitchCommand()
            return
        }
        if (sender as! UISwitch).on {
            writer.removePreviusAccelerationStream()
            writer.openAccelerationStream()
        } else {
            writer.closeAccelerationStream()
        }
    }
    
    @IBAction func wantsGryoscope(sender: AnyObject) {
        if self.isRunning {
            (sender as! UISwitch).on = !(sender as! UISwitch).on
            presentAlertForNotAllowedSwitchCommand()
            return
        }
        if (sender as! UISwitch).on {
            writer.removePreviusGyroscopeStream()
            writer.openGyroscopeStream()
        } else {
            writer.closeGyroscopeStream()
        }
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
        if self.isRunning {
            (sender as! UISwitch).on = !(sender as! UISwitch).on
            presentAlertForNotAllowedSwitchCommand()
            return
        }
        if (sender as! UISwitch).on {
            writer.removePreviusDeviceMotionStream()
            writer.openDeviceMotionStream()
        } else {
            writer.closeDeviceMotionStream()
        }
    }
    
    @IBAction func wantsAttitide(sender: AnyObject) {
        if self.isRunning {
            (sender as! UISwitch).on = !(sender as! UISwitch).on
            presentAlertForNotAllowedSwitchCommand()
            return
        }
        if (sender as! UISwitch).on {
            writer.removePreviusAttitudeStream()
            writer.openAttitudeStream()
        } else {
            writer.closeAttitudeStream()
        }
    }
    
    @IBAction func startStopAction(sender: AnyObject) {
        if (sender as! UIButton).currentTitle == "Stop" {
            self.stopSensorsAcquisition()
            self.isRunning = false
            self.spinOutlet.hidden = true
            self.spinOutlet.stopAnimating()
            (sender as! UIButton).setTitle("Start", forState: UIControlState.Normal)
        } else {
            if getAccelerationSwitch.on == false
                    && getAttitudeSwitch.on == false
                        && getGryscopeSwitch.on == false
                            && getDeviceMotionSwitch.on == false {
                let alert = UIAlertController(title: self.title,
                message: "You haven't selected any acquisition options",
                                preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            self.isRunning = true
            self.startSensorsAcquisition()
            self.spinOutlet.hidden = false
            self.spinOutlet.startAnimating()
            (sender as! UIButton).setTitle("Stop", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func updateFrequencySliderAction(sender: AnyObject) {
        self.preferredUpdateFrequency = Double((sender as! UISlider).value)
        frequencyLabel.text = String(Int((sender as! UISlider).value))
    }

    func presentAlertForNotAllowedSwitchCommand() {
        let alert = UIAlertController(title: self.title,
            message: "You need first to stop the data acquisition",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

