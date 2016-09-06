//
//  LapStringModel.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class LapStringModel: NSObject {
    lazy var lapTimesArray: [String] = {
        let lapDataPersistance = LapStringDataPersistance()
        return lapDataPersistance.fetchAllLapStrings()
    }()

}
