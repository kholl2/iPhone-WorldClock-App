//
//  LapTimerModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class LapTimerModel: NSObject {
    lazy var lapTimerData: Double = {
        let lapTimerDataPersistance = LapTimerDataPersistance()
        return lapTimerDataPersistance.fetchTimerData()
    }()
}
