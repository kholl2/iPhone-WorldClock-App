//
//  LapStringDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation
import CoreData

class LapStringDataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save the laps
    func insertLapTimeDataFromDataArray(lapTimes: LapStringData) {
        //for time in times {
        let timeEntity = NSEntityDescription.insertNewObjectForEntityForName("LapStringEntity", inManagedObjectContext: context) as! LapStringEntity
        timeEntity.lapString = lapTimes.lapString
        // }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch
    func fetchAllLapStrings() -> [String] {
        // let entity = NSEntityDescription.entityForName("TimeEntity", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: "LapStringEntity")
        do {
            var lapStrings = [String]()
           
            let results = try context.executeFetchRequest(fetchRequest)
            
            for laps in results {
                lapStrings.insert(laps.valueForKey("lapString") as! String, atIndex: 0)
            }
            return lapStrings
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
        
        
    }
    
    //delete
    func deleteTime() {
        let fetchRequest = NSFetchRequest(entityName: "LapStringEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try AppDelegate.sharedManager().persistentStoreCoordinator.executeRequest(deleteRequest, withContext: context)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
}

