//
//  StartButtonStatus.swift
//  project3
//
//  Created by Kruthika Holla on 11/25/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation

class StartButtonStatus {
    lazy var startIsActive: Bool = {
        let startDataPersistance = StartButtonDataPersistance()
        return startDataPersistance.fetchStartButtonData()
    }()
    
    
}
