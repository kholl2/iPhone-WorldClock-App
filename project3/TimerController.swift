//
//  ViewController.swift
//  Holla1
//
//  Created by Kruthika Holla on 9/10/15.
//  Copyright (c) 2015 Kruthika Holla. All rights reserved.
//

import UIKit


class TimerController: UIViewController,UITableViewDataSource, UITableViewDelegate, DataSourceTimer  {

    var model = TimerModel()
    var startButtonStatus: StartButtonStatus = StartButtonStatus()
    var startButtonStatusData: StartButtonData?
    var minutesDisplay = String()
    var secondsDisplay = String()
    var milliSecondsDisplay = String()
    var timeStringData: TimerStringData?
    var stringModel: TimerStringModel = TimerStringModel()
    var lapStringModel: LapStringModel = LapStringModel()
    
    @IBOutlet weak var displayTimer: UILabel!
    
    @IBOutlet weak var displayLap: UILabel!
    
   
    
    @IBOutlet weak var tableOutlet: UITableView!
    @IBOutlet weak var startOutlet: UIButton!
    
    
    //MARK: start button of the timer
    @IBAction func startButton(sender: AnyObject) {
        
        if (startButtonStatus.startIsActive){
            startButtonStatus.startIsActive = !startButtonStatus.startIsActive
           
            
            startOutlet.setTitle("Stop", forState: UIControlState())
            startOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState())
            startOutlet.backgroundColor = UIColor.whiteColor()
            lapOutlet.enabled = true
            lapOutlet.setTitle("Lap", forState: UIControlState())
            lapOutlet.setTitleColor(UIColor.blackColor(), forState: UIControlState())
            
            //starts the timer
            
            if (!model.timerIsActive){
                model.fireTimer()
                model.timerIsActive = true
            }
                
                //resumes the timer
            else{
                
                model.resumeTimer()
            }
            
            
        }
            //pauses the timer
        else{
            
            startButtonStatus.startIsActive = !(startButtonStatus.startIsActive)
            model.timerIsActive = true
            startOutlet.setTitle("Start", forState: UIControlState())
            startOutlet.setTitleColor(UIColor.greenColor(), forState: UIControlState())
            startOutlet.backgroundColor = UIColor.whiteColor()
            
            lapOutlet.setTitle("Reset", forState: UIControlState())
            lapOutlet.setTitleColor(UIColor.blackColor(), forState: UIControlState())
            lapOutlet.backgroundColor = UIColor.whiteColor()
            timeStringData = TimerStringData(lapTimerDisplayString: displayLap.text!,timerDisplayString: displayTimer.text!)
            model.stopTimer()
        }
        
        startButtonStatusData = StartButtonData(startIsActive: startButtonStatus.startIsActive)
        saveStartButtonData()
    }
    
    func saveStartButtonData() {
        let startButtonPersistance = StartButtonDataPersistance()
        if let data = startButtonStatusData {
            startButtonPersistance.insertBoolData(data)
        }
        let stringDataPersistance = TimerStringDataPersistance()
        if let timerData = timeStringData {
            stringDataPersistance.insertTimerStringData(timerData)
        }
    }
    
    @IBOutlet weak var lapOutlet: UIButton! //Outlet for the lap button
    
    
    //MARK: lap button of the timer
    @IBAction func lapButton(sender: AnyObject) {
        //MARK:if lap button is pressed
        if (!startButtonStatus.startIsActive){
            model.lapButtonPressed(displayLap.text!)
            model.saveLapData()
            self.displayLap.text = "00:00:00"
            lapStringModel = LapStringModel()
            //MARK: update the table
            var indPath:[NSIndexPath] = [NSIndexPath]()
            indPath.append(NSIndexPath(forRow:0,inSection:0))
            self.tableOutlet.beginUpdates()
            self.tableOutlet.insertRowsAtIndexPaths(indPath, withRowAnimation: UITableViewRowAnimation.Top)
            self.tableOutlet.endUpdates()
        }
            
            //MARK: if reset button is pressed
        else{
            model.resetTimer()
            model.deleteLapData()
            lapStringModel = LapStringModel()
            displayLap.text = "00:00:00"
            displayTimer.text = "00:00:00"
            
            tableOutlet.reloadData() //reload the table
            
            model.timerIsActive = false
            
            lapOutlet.setTitle("Lap", forState: UIControlState())
            lapOutlet.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState())
            lapOutlet.backgroundColor = UIColor.whiteColor()
            lapOutlet.enabled = false
             timeStringData = TimerStringData(lapTimerDisplayString: displayLap.text!,timerDisplayString: displayTimer.text!)
        }
        saveStartButtonData()
        
        
    }
    
    //Starts from where it was left off
    override func viewDidAppear(animated: Bool) {
        //If timer was running
        if (!startButtonStatus.startIsActive){
            model.timerIsActive = true
            model.fireTimerAfterViewChange()
            //startButtonStatus.startIsActive = !(startButtonStatus.startIsActive)
            startOutlet.setTitle("Stop", forState: UIControlState())
            startOutlet.setTitleColor(UIColor.redColor(), forState: UIControlState())
            startOutlet.backgroundColor = UIColor.whiteColor()
            lapOutlet.enabled = true
            lapOutlet.setTitle("Lap", forState: UIControlState())
            lapOutlet.setTitleColor(UIColor.blackColor(), forState: UIControlState())
            
        }
            
         //If timer was not running
        else{
            
            startOutlet.setTitle("Start", forState: UIControlState())
            startOutlet.setTitleColor(UIColor.greenColor(), forState: UIControlState())
            startOutlet.backgroundColor = UIColor.whiteColor()
            lapOutlet.enabled = true
            if(stringModel.lapTimerDisplayString == "" && stringModel.timerDisplayString == ""){
                displayLap.text = "00:00:00"
                displayTimer.text = "00:00:00"
            }
            else{
                displayLap.text = stringModel.lapTimerDisplayString
                displayTimer.text = stringModel.timerDisplayString
                if (stringModel.lapTimerDisplayString == "00:00:00" && stringModel.timerDisplayString == "00:00:00"){
                    model.timerIsActive = false
                }
                else{
                    model.timerIsActive = true
                }
            }
            
            
            lapOutlet.setTitle("Reset", forState: UIControlState())
            lapOutlet.setTitleColor(UIColor.blackColor(), forState: UIControlState())
            lapOutlet.backgroundColor = UIColor.whiteColor()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOutlet.delegate = self
        tableOutlet.dataSource = self
        model.delegate = self
        
        startOutlet.setTitleColor(UIColor.greenColor(), forState: UIControlState())
        startOutlet.backgroundColor = UIColor.whiteColor()
        
        
        startOutlet.layer.cornerRadius = startOutlet.frame.size.width/2
        lapOutlet.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState())
        lapOutlet.backgroundColor = UIColor.whiteColor()
        lapOutlet.layer.cornerRadius = lapOutlet.frame.size.width/2
        lapOutlet.enabled = false
        
    }
    
    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        if(!startButtonStatus.startIsActive){
            model.saveRetrievedData()
            model.saveLapRetrievedData()
        }
        model.saveTimePassedData()
        saveStartButtonData()
        
    }
    //MARK: timer display
    
    func timerDataUpdate(timerData: [String : Int]) {
        
        
        let timerMinutes: Int = timerData["timerMinutes"]!
        minutesDisplay = String (format: "%02d", timerMinutes)
        let timerSeconds: Int = timerData["timerSeconds"]!
        secondsDisplay = String (format: "%02d",timerSeconds)
        let timerMilliSeconds: Int = timerData["timerMilliSeconds"]!
        milliSecondsDisplay = String (format: "%02d",timerMilliSeconds)
        self.displayTimer.text =  "\(minutesDisplay):\(secondsDisplay):\(milliSecondsDisplay)"
        
    }
    
    //MARK: lap timer display
    func lapTimerDataUpdate(lapTimerData: [String : Int]) {
        let lapTimerMinutes: Int = lapTimerData["lapTimerMinutes"]!
        let lapMinutesDisplay = String (format: "%02d", lapTimerMinutes)
        let lapTimerSeconds: Int = lapTimerData["lapTimerSeconds"]!
        let lapSecondsDisplay = String (format: "%02d",lapTimerSeconds)
        let lapTimerMilliSeconds: Int = lapTimerData["lapTimerMilliSeconds"]!
        let lapMilliSecondsDisplay = String (format: "%02d",lapTimerMilliSeconds)
        self.displayLap.text =  "\(lapMinutesDisplay):\(lapSecondsDisplay):\(lapMilliSecondsDisplay)"
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       // return model.lapArray.count
        return lapStringModel.lapTimesArray.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let lapNumber = lapStringModel.lapTimesArray.count - indexPath.row
        cell.textLabel?.text = "Lap \(lapNumber)"
        cell.textLabel?.textColor = UIColor.lightGrayColor()

        
        cell.detailTextLabel!.text = lapStringModel.lapTimesArray[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Left
        return cell
    }
}

