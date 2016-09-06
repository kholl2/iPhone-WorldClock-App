//
//  TimePassedEntity+CoreDataProperties.swift
//  project3
//
//  Created by Kruthika Holla on 11/26/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

//saves main and lap timer time passed
import Foundation
import CoreData

extension TimePassedEntity {

    @NSManaged var timePassedAttr: NSNumber?
    @NSManaged var lapTimePassedAttr: NSNumber?

}
