//
//  ClockFace.swift
//  project3
//
//  Created by Kruthika Holla on 11/20/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit



class ClockFace: CATransformLayer {
    
    private var gradient = CAGradientLayer()
    private var circle = CAShapeLayer()
    private var secondsHand = CAShapeLayer()
    private var minutesHand = CAShapeLayer()
    private var hoursHand = CAShapeLayer()
    
    var currentTime: String?
    
    
    override init() {
        super.init()
        addSublayer(gradient)
        addSublayer(circle)
        addSublayer(secondsHand)
        addSublayer(minutesHand)
        addSublayer(hoursHand)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    func getCurrentTime(timeString: String) {
        currentTime = timeString
    }
    
    override func layoutSublayers() {
        
        //Gradient
        gradient.contentsScale = UIScreen.mainScreen().scale
        gradient.frame = bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.locations = [0, 1]
        gradient.zPosition = 0
        
        
        //Circle
        circle.contentsScale = UIScreen.mainScreen().scale
        circle.lineWidth = 1.0
        circle.fillColor = UIColor.clearColor().colorWithAlphaComponent(0.05).CGColor
        //circle.strokeColor = UIColor.blackColor().CGColor
        let path: CGMutablePathRef = CGPathCreateMutable()
        let rectOutsideEllipse = CGRectInset(bounds, 3, 3)
        CGPathAddEllipseInRect(path, nil, rectOutsideEllipse)
        circle.path = path
        circle.bounds = bounds
        
        circle.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        let xOrigin = CGRectGetMidX(rectOutsideEllipse)
        let yOrigin = CGRectGetMidY(rectOutsideEllipse)
        let radius = (CGRectGetWidth(circle.bounds) / 2) - 10
        
        //Adding numbers
        let clockNumbers = ["3", "4", "5","6", "7", "8","9", "10", "11", "12", "1", "2" ]
        for index in 0..<clockNumbers.count{
            let textLayer = CATextLayer()
            textLayer.contentsScale = UIScreen.mainScreen().scale
            textLayer.string = clockNumbers[index]
            textLayer.bounds = CGRectMake(0, 0, 20, 20)
            textLayer.fontSize = 12
            textLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            //let vertex: CGFloat = CGRectGetMidY(circle.bounds) / CGRectGetHeight(textLayer.bounds)
            textLayer.anchorPoint = CGPointMake(0.5, 0.5)
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.foregroundColor = UIColor.blackColor().CGColor
            //textLayer.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(Double(index) * M_PI / 6.0)))

            let xPosition = xOrigin + (radius * cos(CGFloat(Double(index) * M_PI / 6.0)))
            let yPosition = yOrigin +  (radius * sin(CGFloat(Double(index) * M_PI / 6.0 )))
           
            
            
            textLayer.position = CGPoint(x: xPosition, y: yPosition)
           
            circle.addSublayer(textLayer)
            
            textLayer.zPosition = 100
        }
        circle.zPosition = 10
        
        //seconds hand
        secondsHand.contentsScale = UIScreen.mainScreen().scale
        secondsHand.lineWidth = 1.0
        secondsHand.bounds = bounds
        secondsHand.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        secondsHand.anchorPoint = CGPointMake(0.5, 0.5)

        let linePath:UIBezierPath = UIBezierPath()
        linePath.moveToPoint(CGPointMake(CGRectGetMidX(rectOutsideEllipse), CGRectGetMidY(rectOutsideEllipse)))
        
        let currentTimeSplit = currentTime!.componentsSeparatedByString(":")
        
        let secondsInInt: Double = Double(currentTimeSplit[2])!
        let xPosition = xOrigin + (radius * cos(CGFloat((secondsInInt+45.0) * M_PI) / 30.0))
        let yPosition = yOrigin +  (radius * sin(CGFloat((secondsInInt+45.0) * M_PI) / 30.0))
        
        
       // linePath.addLineToPoint(CGPointMake(CGRectGetMidX(rectOutsideEllipse), CGRectGetMidY(rectOutsideEllipse)-40))
        linePath.addLineToPoint(CGPointMake(xPosition, yPosition))
        
        
        secondsHand.path = linePath.CGPath
        secondsHand.fillColor = nil
        //secondsHand.opacity = 2.0
        secondsHand.strokeColor = UIColor.redColor().CGColor
        secondsHand.zPosition = 40;
        
        //minutes hand
        minutesHand.contentsScale = UIScreen.mainScreen().scale
        minutesHand.lineWidth = 2.0
        minutesHand.bounds = bounds
        minutesHand.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        minutesHand.anchorPoint = CGPointMake(0.5, 0.5)
        let minutesPath:UIBezierPath = UIBezierPath()
        minutesPath.moveToPoint(CGPointMake(CGRectGetMidX(rectOutsideEllipse), CGRectGetMidY(rectOutsideEllipse)))
        
        
        let minutesInInt: Double = Double(currentTimeSplit[1])!
        let minutesXPosition = xOrigin + (radius * cos(CGFloat((minutesInInt+45.0) * M_PI * 60  * 2) / 3600.0))
        let minutesYPosition = yOrigin +  (radius * sin(CGFloat((minutesInInt+45.0) * M_PI * 60  * 2) / 3600.0))
        
        minutesPath.addLineToPoint(CGPointMake(minutesXPosition, minutesYPosition))
        minutesHand.path = minutesPath.CGPath
        minutesHand.fillColor = nil
        minutesHand.opacity = 2.0
        minutesHand.strokeColor = UIColor.blackColor().CGColor
        
        minutesHand.zPosition = 30
        
        hoursHand.contentsScale = UIScreen.mainScreen().scale
        hoursHand.lineWidth = 3.0
        hoursHand.bounds = bounds
        hoursHand.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        hoursHand.anchorPoint = CGPointMake(0.5, 0.5)
        let hoursPath:UIBezierPath = UIBezierPath()
        hoursPath.moveToPoint(CGPointMake(CGRectGetMidX(rectOutsideEllipse), CGRectGetMidY(rectOutsideEllipse)))
        
        let hoursInInt: Double = Double(currentTimeSplit[0])!
        let totalMinutes = (hoursInInt * 60) + minutesInInt
        
        let hoursXPosition = xOrigin + (radius/1.5 * cos(CGFloat((totalMinutes-180.0) * M_PI * 2) / 720.0))
        let hoursYPosition = yOrigin +  (radius/1.5 * sin(CGFloat((totalMinutes-180.0) * M_PI * 2) / 720.0))
        

        
        hoursPath.addLineToPoint(CGPointMake(hoursXPosition, hoursYPosition))
        
        hoursHand.path = hoursPath.CGPath
        hoursHand.fillColor = nil
        hoursHand.opacity = 2.0
        hoursHand.strokeColor = UIColor.blackColor().CGColor
        
        hoursHand.zPosition = 35
        
        
    }
    
    func rotateSecondsHandWithTransform(transform: CGAffineTransform) {
        //CATransaction.setAnimationDuration(1.0)
        secondsHand.setAffineTransform(transform)
    }
    
    func rotateMinutesHandWithTransform(transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(1.0)
        minutesHand.setAffineTransform(transform)
    }
    
    func rotateHoursHandWithTransform(transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(1.0)
        hoursHand.setAffineTransform(transform)
    }
    

    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
