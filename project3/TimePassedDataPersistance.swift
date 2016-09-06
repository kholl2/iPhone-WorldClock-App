//
//  TimePassedDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit
import CoreData

class TimePassedDataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save data
    func insertTimePassedData(timerPassed: TimePassedData) {
        let timeEntity = NSEntityDescription.insertNewObjectForEntityForName("TimePassedEntity", inManagedObjectContext: context) as! TimePassedEntity
        timeEntity.lapTimePassedAttr = NSNumber(double:timerPassed.lapTimePassedAttr)
        timeEntity.timePassedAttr = NSNumber(double:timerPassed.timePassedAttr)

        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch time passed
    func fetchTimePassedData() -> Double {
        let entity = NSEntityDescription.entityForName("TimePassedEntity", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["timePassedAttr"])!]
        fetchRequest.includesPropertyValues = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            var timePassed = Double()
            let results = try context.executeFetchRequest(fetchRequest)
            for tPassed in results {
                timePassed = tPassed.valueForKey("timePassedAttr") as! Double
                
            }
            return timePassed
        } catch let error as NSError {
            print(error.localizedDescription)
            return 0.0
        }
    }
    
    //fetch lap time passed
    func fetchLapTimePassedData() -> Double {
        let entity = NSEntityDescription.entityForName("TimePassedEntity", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["lapTimePassedAttr"])!]
        fetchRequest.includesPropertyValues = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            var lapTimePassed = Double()
            let results = try context.executeFetchRequest(fetchRequest)

            for tPassed in results {
                lapTimePassed = tPassed.valueForKey("lapTimePassedAttr") as! Double
                
            }
            return lapTimePassed
        } catch let error as NSError {
            print(error.localizedDescription)
            return 0.0
        }
    }
}

