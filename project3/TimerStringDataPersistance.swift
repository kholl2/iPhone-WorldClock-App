//
//  TimerStringDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/25/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit
import CoreData

class TimerStringDataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save the strings
    func insertTimerStringData(timerString: TimerStringData) {
       
            let stringEntity = NSEntityDescription.insertNewObjectForEntityForName("TimerString", inManagedObjectContext: context) as! TimerString
            stringEntity.timerDisplayString = timerString.timerDisplayString
            stringEntity.lapTimerDisplayString = timerString.lapTimerDisplayString
       
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch timer string
    func fetchTimerStringData() -> String {
        let entity = NSEntityDescription.entityForName("TimerString", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["timerDisplayString"])!]
        fetchRequest.includesPropertyValues = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            var timerString = String()
            let results = try context.executeFetchRequest(fetchRequest)
            
            for tString in results {
                timerString = tString.valueForKey("timerDisplayString") as! String
                
            }
            return timerString
        } catch let error as NSError {
            print(error.localizedDescription)
            return "00:00:00"
        }
    }
    
    //fetch lap timer string
    func fetchLapTimerStringData() -> String {
        let entity = NSEntityDescription.entityForName("TimerString", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["lapTimerDisplayString"])!]
        fetchRequest.includesPropertyValues = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            var timerString = String()
            let results = try context.executeFetchRequest(fetchRequest)
            
            for tString in results {
                timerString = tString.valueForKey("lapTimerDisplayString") as! String
                
            }
            return timerString
        } catch let error as NSError {
            print(error.localizedDescription)
            return "00:00:00"
        }
    }
}
