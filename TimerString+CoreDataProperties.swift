//
//  TimerString+CoreDataProperties.swift
//  project3
//
//  Created by Kruthika Holla on 11/25/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

//saves timer and lap display string
import Foundation
import CoreData

extension TimerString {

    @NSManaged var timerDisplayString: String?
    @NSManaged var lapTimerDisplayString: String?

}
