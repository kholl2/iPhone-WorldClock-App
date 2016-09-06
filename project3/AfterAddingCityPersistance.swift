//
//  AfterAddingCityPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/28/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation
import CoreData

class AfterAddingCityPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save
    func insertCityArray(cArray: [AfterAddingCityData]) {
        for city in cArray {
            let delCityEntity = NSEntityDescription.insertNewObjectForEntityForName("FinalCityEntity", inManagedObjectContext: context) as! FinalCityEntity
            delCityEntity.cityArray = city.cityArray
        
        }
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch
    func fetchAllCities() -> [String] {
        let entity = NSEntityDescription.entityForName("FinalCityEntity", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: "FinalCityEntity")
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["cityArray"])!]
        //fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
    
        let sortAsc = NSSortDescriptor(key: "cityArray", ascending: true)
        fetchRequest.sortDescriptors = [sortAsc]
        do {
            var cities = [String]()
            let results = try context.executeFetchRequest(fetchRequest)
            for city in results {
                cities.append(city.valueForKey("cityArray") as! String)
            }
            return cities
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
        

    
    //delete
    func deleteCity() {
        let fetchRequest = NSFetchRequest(entityName: "FinalCityEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try AppDelegate.sharedManager().persistentStoreCoordinator.executeRequest(deleteRequest, withContext: context)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
}

