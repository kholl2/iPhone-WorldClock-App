//
//  TimerDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/24/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//


import Foundation
import CoreData

class TimerDataPersistance {
    
    private let context: NSManagedObjectContext

    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save timer data
    func insertTimerDataFromDataArray(time: MainTimerData) {
        let mainTimerEntity = NSEntityDescription.insertNewObjectForEntityForName("MainTimerEntity", inManagedObjectContext: context) as! MainTimerEntity
        mainTimerEntity.timerData = NSNumber(double: time.timerData)
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch
    func fetchTimerData() -> Double {
        let fetchRequest = NSFetchRequest(entityName: "MainTimerEntity")
        do {
            var timerData = Double()
            let results = try context.executeFetchRequest(fetchRequest)
            for tString in results {
                timerData = tString.valueForKey("timerData") as! Double
            }
            return timerData
        } catch let error as NSError {
            print(error.localizedDescription)
            return 0.0
        }
        
        
    }
    
    //delete
    func deleteTimerData() {
        let fetchRequest = NSFetchRequest(entityName: "MainTimerEntity")
        fetchRequest.includesPropertyValues = true
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for entity in results {
                    context.deleteObject(entity)
            }
            try context.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        print("timer data deleted")
    }
    
    
    
}
