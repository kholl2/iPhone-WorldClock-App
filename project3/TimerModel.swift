//
//  TimerModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/24/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

protocol DataSourceTimer: class{
    func timerDataUpdate (timerData: [String: Int])
    func lapTimerDataUpdate (lapTimerData: [String: Int])
}


class TimerModel: NSObject {

    var timerIsActive = Bool()
    weak var delegate: DataSourceTimer?
    var timerStartTime = NSTimeInterval()
    var lapStartTime = NSTimeInterval()
    var timePassed = NSTimeInterval()
    var lapTimePassed = NSTimeInterval()
    var lapArray = [String]()
    var timer = NSTimer()
    var mainTimerData: MainTimerData?
    var coreModel: MainTimerModel = MainTimerModel()
    var timePassedData: TimePassedData?
    var timeModel: TimePassedModel = TimePassedModel()
    var lapTimerData: LapTimerData?
    var lapCoreModel: LapTimerModel = LapTimerModel()
    var lapStrings: [LapStringData]?
    
    override init() {
        timerIsActive = false
        lapArray = []
        lapStrings = []
    }
    
    
    //get timer and lap timer data
    func timerSetter(){
        var timerData = [String: Int]()
        var lapTimerData = [String: Int]()
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        
        timePassed = currentTime - coreModel.timerData
        
        
        lapTimePassed = currentTime - lapStartTime
        
        let minutesPassed: Int = Int(timePassed) / 60
        timerData["timerMinutes"] = Int(minutesPassed)
        
        let secondsTimePassed: NSTimeInterval = timePassed - (NSTimeInterval)(minutesPassed * 60)
        let secondsPassed: Int = Int(secondsTimePassed)
        timerData["timerSeconds"] = Int(secondsPassed)
        
        let milliTimePassed: NSTimeInterval = secondsTimePassed - (NSTimeInterval)(secondsPassed)
        let milliSecondsPassed: Int = Int(milliTimePassed * 100)
        timerData["timerMilliSeconds"] = Int(milliSecondsPassed)
        
        

        
        delegate?.timerDataUpdate(timerData)

        
        let lapMinutesPassed: Int = Int (lapTimePassed / 60)
        lapTimerData["lapTimerMinutes"] = Int(lapMinutesPassed)
        
        let lapSecondsTimePassed: NSTimeInterval = lapTimePassed - (NSTimeInterval)(lapMinutesPassed * 60)
        let lapSecondsPassed: Int = Int(lapSecondsTimePassed)
        lapTimerData["lapTimerSeconds"] = Int(lapSecondsPassed)
        
        
        let lapMilliTimePassed: NSTimeInterval = lapSecondsTimePassed - (NSTimeInterval)(lapSecondsPassed)
        let lapMilliSecondsPassed: Int = Int(lapMilliTimePassed * 100)
        lapTimerData["lapTimerMilliSeconds"] = Int(lapMilliSecondsPassed)
        delegate?.lapTimerDataUpdate(lapTimerData )
        
       
        
    }
    //MARK: persistance for timer
    func saveRetrievedData() {
        let timePersistance = TimerDataPersistance()
        if let data = mainTimerData {
            //let count = data.count
            
            timePersistance.insertTimerDataFromDataArray(data)
        }
    }
    
    func saveLapRetrievedData() {
        let lapTimePersistance = LapTimerDataPersistance()
        if let data = lapTimerData {

            lapTimePersistance.insertTimerDataFromDataArray(data)
        }
    }
    
    func saveTimePassedData(){
        let timePassedPersistance = TimePassedDataPersistance()
        if let data = timePassedData {
            
            timePassedPersistance.insertTimePassedData(data)
        }
    }
    
    func saveLapData() {
        let lapStringPersistance = LapStringDataPersistance()
        if let data = lapStrings {
            lapStringPersistance.insertLapTimeDataFromDataArray(data[0])
        }
    }
    
    func deleteData() {
        let timePersistance = TimerDataPersistance()
        timePersistance.deleteTimerData()
    }
    
    func deleteLapData() {
        let lapTimePersistance = LapStringDataPersistance()
        lapTimePersistance.deleteTime()
    }
    
    //fire the timer
    func fireTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timerSetter", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        timerStartTime  = NSDate.timeIntervalSinceReferenceDate()
        lapStartTime = timerStartTime
        mainTimerData = MainTimerData(timerData: timerStartTime)
        saveRetrievedData()
    }
    
    //fire timer after view change
    func fireTimerAfterViewChange(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timerSetter", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        timerStartTime = coreModel.timerData
        
        if(lapCoreModel.lapTimerData == 0.0){
            lapStartTime = timerStartTime
        }
        else{
            lapStartTime = lapCoreModel.lapTimerData
        }
        lapTimerData = LapTimerData(lapTimerData: lapStartTime)
        saveLapRetrievedData()
        mainTimerData = MainTimerData(timerData: timerStartTime)
        saveRetrievedData()
    }
    
    //stop timer
    func stopTimer(){
        timePassedData = TimePassedData(lapTimePassedAttr: lapTimePassed, timePassedAttr: timePassed)
        saveTimePassedData()
        timeModel = TimePassedModel()
        timer.invalidate()
    }
    
    //reset
    func resetTimer(){
        timer.invalidate()
        deleteData()
        coreModel = MainTimerModel()
        lapCoreModel = LapTimerModel()
        lapArray.removeAll()
    }
    
    //resume
    func resumeTimer(){
        
        fireTimer()
        timerStartTime  = NSDate.timeIntervalSinceReferenceDate() - timeModel.timePassedAttr
        lapStartTime = NSDate.timeIntervalSinceReferenceDate() - timeModel.lapTimePassedAttr
        mainTimerData = MainTimerData(timerData: timerStartTime)
        saveRetrievedData()
        lapTimerData = LapTimerData(lapTimerData: lapStartTime)
        saveLapRetrievedData()
        coreModel = MainTimerModel()
        lapCoreModel = LapTimerModel()
        
    }
    
    //If lap is pressed
    func lapButtonPressed (currentLapTime: String){
        lapArray.insert(currentLapTime, atIndex: 0)
        lapStrings?.insert(LapStringData(lapString: currentLapTime), atIndex: 0)
        
        lapStartTime += lapTimePassed
        lapTimerData = LapTimerData(lapTimerData: lapStartTime)
        saveLapRetrievedData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
