//
//  WorldClockModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/10/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

protocol MainModelDelegate: class {
    func receiveFailedForTime()
    func reload()
}


class WorldClockModel: NSObject {
    var displayClockForCities :[String]?
    var finalCityArray: [String] = []
    var timer = NSTimer()
    var minuteTimer = NSTimer()
    weak var delegate: MainModelDelegate?
    var timeLocations: [TimeData]?
    var cityAfterAdd: [AfterAddingCityData]?
    
    override init(){
        displayClockForCities = []
        timeLocations = []
        cityAfterAdd = []
    }
    
    
    //MARK: Adding cities
    func cityAdded (city: String?){
        displayClockForCities?.insert(city!, atIndex: (displayClockForCities?.count)!)
        guard let location = city as String! else{
            self.delegate?.receiveFailedForTime()
            return
        }
        timeLocations?.append(TimeData(currentCity: location))
    }
    //save added cities
    func saveRetrievedData() {
        let timePersistance = DataPersistance()
        if let data = timeLocations {
            let count = data.count
            timePersistance.insertTimeDataFromDataArray(data[count-1])
        }
    }
    
    
    //delete the cities
    func deleteData(time: String) {
        let timePersistance = DataPersistance()
        timePersistance.deleteTime(time)
    }
    
    //get the citylist to display
    func getCityList(){
        let cityArrayWithContinents = NSTimeZone.knownTimeZoneNames()
        for var i in 0 ..< cityArrayWithContinents.count{
            let cityArrayTemp = cityArrayWithContinents[i].componentsSeparatedByString("/")
            
            let city = cityArrayTemp.last!
            let finalCity = city.stringByReplacingOccurrencesOfString("_", withString: " ")
            var cityExtension = String()
            if (cityArrayTemp.count > 1){
                cityExtension = cityArrayTemp[cityArrayTemp.count - 2].stringByReplacingOccurrencesOfString("_", withString: " ")
            }
            else{
                cityExtension = cityArrayTemp[cityArrayTemp.count - 1].stringByReplacingOccurrencesOfString("_", withString: " ")
            }
            
            let finalCityWIthExtension = "\(finalCity), \(cityExtension)"
            finalCityArray.append(finalCityWIthExtension)
            i++;
        }
        finalCityArray.sortInPlace()
        if(cityAfterAdd?.count == 0) {
            for city in finalCityArray{
                cityAfterAdd?.append(AfterAddingCityData(cityArray: city))
            }
        }
    }
    
    //MARK: added city persistance
    func saveAddedCityData() {
        let addedCityPersistance = AfterAddingCityPersistance()
        if let data = cityAfterAdd {
            addedCityPersistance.insertCityArray(data)
        }
        
    }
    
    func deleteCityData(){
        let cityDataPersistance = AfterAddingCityPersistance()
        cityDataPersistance.deleteCity()
    }
    
    //get the location of the selected city
    private func getLocation(city: String) -> String{
        let cityArrayWithContinents = NSTimeZone.knownTimeZoneNames()
        let cityTemp = city.componentsSeparatedByString(",")
        for var i in 0 ..< cityArrayWithContinents.count{
            let cityArrayTemp = cityArrayWithContinents[i].componentsSeparatedByString("/")
            let cityExtension = cityArrayTemp.last!.stringByReplacingOccurrencesOfString("_", withString: " ")
            if (cityTemp[0] == cityExtension){
                return cityArrayWithContinents[i]
            }
            i++
        }
        return cityArrayWithContinents.last!
    }
    
    //get timezone
    
    func getDigitalTimeUpdate(location: String){
        let currentTime = getCurrentTimeForLocationWithSeconds(location)
        let currentTimeSplit = currentTime.componentsSeparatedByString(":")
        let currentSecond = Double(currentTimeSplit[2])
        let fireTime = 60.0 - currentSecond!
        timer = NSTimer.scheduledTimerWithTimeInterval(fireTime, target: self, selector: "getDataForDigitalTime:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func getDataForDigitalTime(timer: NSTimer){
        delegate?.reload()
    }
    
    func getCurrentTimeForLocation (location: String) -> String{
        let cityLocation = getLocation(location)
        let date = NSDate()
        let df = NSDateFormatter()
        df.timeZone = (NSTimeZone(name: cityLocation))
        df.dateFormat = " h:mm a"
        let stringFromDate = df.stringFromDate(date)
        return stringFromDate
    }
    
    
    
    //get current time in selected city
    func getCurrentTimeForLocationWithSeconds (location: String) -> String{
        let cityLocation = getLocation(location)
        let date = NSDate()
        let df = NSDateFormatter()
        df.timeZone = (NSTimeZone(name: cityLocation))
        df.dateFormat = "h:mm:ss"
        let stringFromDate = df.stringFromDate(date)
        return stringFromDate
    }
    
    //delete the added cities
    func removeAddedCities(cityIndex: [Int]){
        for ind in cityIndex{
            finalCityArray.removeAtIndex(ind)
        }
    }

    //get offset
    func getOffset(location: String) -> String{
        let cityLocation = getLocation(location)
        let date = NSDate()
        
        
        
        
        let calendar = NSCalendar.currentCalendar()
        
        
        let sourceTimeZone = NSTimeZone(abbreviation: "GMT")
        let currentTimeZone = NSTimeZone.localTimeZone()
        let sourceGMTOffset: NSInteger = (sourceTimeZone?.secondsFromGMTForDate(date))!
        
        let currentGMTOffset: NSInteger = currentTimeZone.secondsFromGMTForDate(date)
        
        let interval: NSTimeInterval = Double(currentGMTOffset) - Double(sourceGMTOffset)
        let chosenCityTimeZone = (NSTimeZone(name: cityLocation))
        let chosenCityOffset = chosenCityTimeZone?.secondsFromGMTForDate(date)
        let cityInterval: NSTimeInterval = Double(chosenCityOffset!) - Double(sourceGMTOffset)
        var chosenCityInterval = interval - cityInterval
        
        let chosenCityDate: NSDate?
        if(chosenCityInterval < 0){
            chosenCityInterval = -(chosenCityInterval)
            chosenCityDate = NSDate().dateByAddingTimeInterval(chosenCityInterval)
             }
             else{
            chosenCityDate = NSDate().dateByAddingTimeInterval(-chosenCityInterval)
            
        }
        
        var offsetInterval = interval - cityInterval
        let hourOffset: Int = Int(offsetInterval) / 3600
        offsetInterval -= Double(hourOffset) * 3600
        let minutesOffset: Int = Int(offsetInterval) / 60
        var positiveHourOffset = Int()
        var positiveMinuteOffset = Int()
        if hourOffset < 0{
            positiveHourOffset = -(hourOffset)
        }
        else{
            positiveHourOffset = hourOffset
        }
        
        if minutesOffset < 0{
            positiveMinuteOffset = -(minutesOffset)
        }
        else{
            positiveMinuteOffset = minutesOffset
        }
        

            
        if(calendar.isDateInToday(chosenCityDate!)){
            if hourOffset < 0 && positiveMinuteOffset == 0{
                return "Today, \(positiveHourOffset) hours ahead"
            }
            else if hourOffset < 0 && positiveMinuteOffset > 0{
                return "Today, \(positiveHourOffset)h \(positiveMinuteOffset)m ahead"
    
            }
            else if hourOffset > 0 && positiveMinuteOffset == 0{
                return "Today, \(positiveHourOffset) hours behind"
            }
            else if hourOffset > 0 && positiveMinuteOffset > 0{
                return "Today, \(positiveHourOffset)h \(positiveMinuteOffset)m behind"
            
            }
            else{
                return "Today"
            
            }
        }
            
        else if(calendar.isDateInYesterday(chosenCityDate!)){
            if positiveMinuteOffset == 0{
                return "Yesterday, \(positiveHourOffset) hours behind"
            }
            else{
                return "Yesterday, \(positiveHourOffset)h \(positiveMinuteOffset)m behind"
            }
        }
        else{
            if positiveMinuteOffset == 0{
                return "Tomorrow, \(positiveHourOffset) hours ahead"
            }
            else{
                return "Tomorrow, \(positiveHourOffset)h \(positiveMinuteOffset)m ahead"
            }
        }
    }
    
    //MARK: Move hands
    func moveHands(hand: UIView, location: String){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "getDataToMoveHands:", userInfo: ["hand": hand, "location": location], repeats: true)
         NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func getDataToMoveHands(timer: NSTimer){
        let dict = timer.userInfo as! NSDictionary
        rotateSecondsHand(dict["hand"] as! UIView, location: dict["location"] as! String)
        rotateMinutesHand(dict["hand"] as! UIView, location: dict["location"] as! String)
        rotateHoursHand(dict["hand"] as! UIView, location: dict["location"] as! String)
        
    }
    
    func rotateSecondsHand(secondsHand: UIView, location: String){
        let timeAtLocation: String = getCurrentTimeForLocationWithSeconds(location)
        let timeAtLocationSplit = timeAtLocation.componentsSeparatedByString(":")
        (secondsHand as! ClockHoldingViewProtocol).moveSecondsHand(timeAtLocationSplit[2])
    }
    
    func rotateMinutesHand(minutesHand: UIView, location: String){
        let timeAtLocation: String = getCurrentTimeForLocationWithSeconds(location)
        let timeAtLocationSplit = timeAtLocation.componentsSeparatedByString(":")
        (minutesHand as! ClockHoldingViewProtocol).moveMinutesHand(timeAtLocationSplit[1], seconds: timeAtLocationSplit[2])
    }
    
    func rotateHoursHand(hoursHand: UIView, location: String){
        let timeAtLocation: String = getCurrentTimeForLocationWithSeconds(location)
        let timeAtLocationSplit = timeAtLocation.componentsSeparatedByString(":")
        (hoursHand as! ClockHoldingViewProtocol).moveHoursHand(timeAtLocationSplit[0], minutes: timeAtLocationSplit[1])
    }
    
}
























