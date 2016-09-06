//
//  StartButtonDataPersistance.swift
//  project3
//
//  Created by Kruthika Holla on 11/25/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import Foundation
import CoreData

class StartButtonDataPersistance {
    
    private let context: NSManagedObjectContext
    
    
    init() {
        let coreDataManager = AppDelegate.sharedManager()
        context = coreDataManager.managedObjectContext
        
    }
    
    //save status of timer
    func insertBoolData(startButton: StartButtonData) {
        let buttonEntity = NSEntityDescription.insertNewObjectForEntityForName("StartButtonBoolEntity", inManagedObjectContext: context) as! StartButtonBoolEntity
        buttonEntity.startIsActive = NSNumber(bool: startButton.startIsActive)
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print("failed to save to core data: \(error.localizedDescription)")
        }
    }
    
    //fetch
    func fetchStartButtonData() -> Bool {
        let entity = NSEntityDescription.entityForName("StartButtonBoolEntity", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.propertiesToFetch = [(entity?.propertiesByName["startIsActive"])!]
        fetchRequest.includesPropertyValues = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        do {
            var startButtonStatusInEntity = Bool()
            let results = try context.executeFetchRequest(fetchRequest)
            
            for buttonData in results {
                startButtonStatusInEntity = buttonData.valueForKey("startIsActive") as! Bool
               
            }
            if results.count == 0{
                startButtonStatusInEntity = true
            }
            return startButtonStatusInEntity
        } catch let error as NSError {
            print(error.localizedDescription)
            return true
        }
        
        
    }
    
    
  
    
    
}



