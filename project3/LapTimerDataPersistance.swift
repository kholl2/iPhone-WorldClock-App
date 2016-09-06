//
//  LapTimerDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation
import CoreData

class LapTimerDataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save lap timer data
    func insertTimerDataFromDataArray(time: LapTimerData) {
        let lapTimerEntity = NSEntityDescription.insertNewObjectForEntityForName("LapTimerEntity", inManagedObjectContext: context) as! LapTimerEntity
        lapTimerEntity.lapTimerData = NSNumber(double: time.lapTimerData)
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch
    func fetchTimerData() -> Double {
        let fetchRequest = NSFetchRequest(entityName: "LapTimerEntity")
        do {
            var timerData = Double()
            let results = try context.executeFetchRequest(fetchRequest)
            for tString in results {
                timerData = tString.valueForKey("lapTimerData") as! Double
            }
            return timerData
        } catch let error as NSError {
            print(error.localizedDescription)
            return 0.0
        }
        
        
    }
    
    
    
}