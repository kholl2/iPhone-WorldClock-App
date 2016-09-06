//
//  ClockView.swift
//  project3
//
//  Created by Kruthika Holla on 11/20/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class ClockView: UIView, ClockHoldingViewProtocol {

    let clockLayer = ClockFace()
    
    override func drawRect(rect: CGRect) {
        clockLayer.frame = rect
        layer.addSublayer(clockLayer)

    }
    
    //MARK: Move hands
    
    func moveSecondsHand(seconds: String) {
        var transform: CGAffineTransform!
        let secondsInInt: Double = Double(seconds)!
        let startTime: String = clockLayer.currentTime!
        let startTimeSplit = startTime.componentsSeparatedByString(":")
        transform = CGAffineTransformMakeRotation(CGFloat((secondsInInt - (Double(startTimeSplit[2])!)) * M_PI) / 30.0)
        clockLayer.rotateSecondsHandWithTransform(transform)
    }
    
    func moveMinutesHand(minutes: String, seconds: String) {
        var transform: CGAffineTransform!
        let minutesInInt: Double = Double(minutes)!
        let secondsInInt: Double = Double(seconds)!
        let total = (minutesInInt * 60) + secondsInInt
        let startTime: String = clockLayer.currentTime!
        let startTimeSplit = startTime.componentsSeparatedByString(":")
        let startingMinute: Double = Double(startTimeSplit[1])!
        let startingSecond: Double = Double(startTimeSplit[2])!
        let startingTotal = (startingMinute * 60) + startingSecond
        transform = CGAffineTransformMakeRotation(CGFloat((total - startingTotal) * M_PI * 2) / 3600.0)
        clockLayer.rotateMinutesHandWithTransform(transform)
    }
    
    func moveHoursHand(hours: String, minutes: String) {

        var transform: CGAffineTransform!
        let hoursinInt: Double = Double(hours)!
        let minutesInInt: Double = Double(minutes)!
        let totalMinutes = (hoursinInt * 60) + minutesInInt
        let startTime: String = clockLayer.currentTime!
        let startTimeSplit = startTime.componentsSeparatedByString(":")
        let totalMinutesInStart = (Double(startTimeSplit[0])!*60) + Double(startTimeSplit[1])!
        transform = CGAffineTransformMakeRotation(CGFloat((totalMinutes - totalMinutesInStart) * M_PI  * 2) / 720.0)
        clockLayer.rotateHoursHandWithTransform(transform)
    }
    
    
    
}
