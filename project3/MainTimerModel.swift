//
//  MainTimerModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/24/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation

class MainTimerModel {
    lazy var timerData: Double = {
        let timerDataPersistance = TimerDataPersistance()
        return timerDataPersistance.fetchTimerData()
    }()
    
    
}
