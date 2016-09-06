//
//  TimePassedModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class TimePassedModel: NSObject {
    lazy var timePassedAttr: Double = {
        let timePassedPersistance = TimePassedDataPersistance()
        return timePassedPersistance.fetchTimePassedData()
    }()
    
    lazy var lapTimePassedAttr: Double = {
        let timePassedPersistance = TimePassedDataPersistance()
        return timePassedPersistance.fetchLapTimePassedData()
    }()
}
