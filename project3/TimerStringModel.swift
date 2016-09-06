//
//  TimerStringModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/25/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class TimerStringModel: NSObject {
    lazy var timerDisplayString: String = {
        let timerStringDataPersistance = TimerStringDataPersistance()
        return timerStringDataPersistance.fetchTimerStringData()
    }()
    
    lazy var lapTimerDisplayString: String = {
        let timerStringDataPersistance = TimerStringDataPersistance()
        return timerStringDataPersistance.fetchLapTimerStringData()
    }()
}
