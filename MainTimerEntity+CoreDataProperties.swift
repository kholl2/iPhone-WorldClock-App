//
//  MainTimerEntity+CoreDataProperties.swift
//  project3
//
//  Created by Kruthika Holla on 11/24/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

//Saves timer data
import Foundation
import CoreData

extension MainTimerEntity {

    @NSManaged var timerData: NSNumber?

}
