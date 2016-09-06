//
//  ClockHoldingView.swift
//  project3
//
//  Created by Kruthika Holla on 11/21/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit


protocol ClockHoldingViewProtocol{
    func moveSecondsHand(seconds: String)
    func moveMinutesHand(minutes: String, seconds: String)
    func moveHoursHand(hours: String, minutes: String)
}

class ClockHoldingView: UIView {

    override func layoutSubviews() {
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        super.layoutSubviews()
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        setupViewForClockView(view)
    }
    
    private func setupViewForClockView(view: UIView) {
        for subview in subviews {
            if view == subview {
                view.translatesAutoresizingMaskIntoConstraints = false
                view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
                view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
                view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
                view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
                view.setNeedsLayout()
                break
            }
        }
    }

}
