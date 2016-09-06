//
//  PushButton.swift
//  project3
//
//  Created by Kruthika Holla on 11/9/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton {

        @IBInspectable var fillColor: UIColor = UIColor.whiteColor()
        //Get a plus button
        override func drawRect(rect: CGRect) {
            let path = UIBezierPath(ovalInRect: rect)
            fillColor.setFill()
            path.fill()
            
            let plusHeight: CGFloat = 1.0
            let plusWidth: CGFloat = min(bounds.width, bounds.height)*0.6
            
            let plusPath = UIBezierPath()
            plusPath.lineWidth = plusHeight
            plusPath.moveToPoint(CGPoint(x: bounds.width/2 - plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
            
            plusPath.addLineToPoint(CGPoint(x: bounds.width/2 + plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
            
            plusPath.moveToPoint(CGPoint(x: bounds.width/2  + 0.5, y: bounds.height/2 - plusWidth/2 + 0.5))
                
            plusPath.addLineToPoint(CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + plusWidth/2 + 0.5))
            
            
            UIColor.redColor().setStroke()
            
            plusPath.stroke()
    }


}
