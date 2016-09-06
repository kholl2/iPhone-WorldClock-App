//
//  DataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/23/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation
import CoreData

class DataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save city
    func insertTimeDataFromDataArray(times: TimeData) {
        //for time in times {
            let timeEntity = NSEntityDescription.insertNewObjectForEntityForName("TimeEntity", inManagedObjectContext: context) as! TimeEntity
            timeEntity.currentCity = times.currentCity
       // }
    
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    

    //fetch
    func fetchAllTimeLocations() -> [String] {
        let fetchRequest = NSFetchRequest(entityName: "TimeEntity")

        do {
            var locations = [String]()
            let results = try context.executeFetchRequest(fetchRequest)
            for city in results {
                locations.append(city.valueForKey("currentCity") as! String)
            }
            return locations
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
        
        
    }
    
    //delete
    func deleteTime(time: String) {
        let fetchRequest = NSFetchRequest(entityName: "TimeEntity")
        fetchRequest.includesPropertyValues = true
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for entity in results {
                if (entity.valueForKey("currentCity") as! String == time){
                    context.deleteObject(entity)
                }
            }
            try context.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    

}
