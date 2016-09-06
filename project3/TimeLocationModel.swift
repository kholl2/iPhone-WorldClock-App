//
//  TimeLocationModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/23/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation

class TimeLocationModel {
    lazy var timeLocationsArray: [String] = {
        let dataPersistance = DataPersistance()
        return dataPersistance.fetchAllTimeLocations()
    }()
    
    
}
