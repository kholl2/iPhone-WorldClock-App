//
//  CitiesAfterSelectionData.swift
//  project3
//
//  Created by Kruthika Holla on 11/28/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class CitiesAfterSelectionModel: NSObject {
    lazy var cityLocationsArray: [String] = {
        let cityDataPersistance = AfterAddingCityPersistance()
        return cityDataPersistance.fetchAllCities()
    }()
    
}
