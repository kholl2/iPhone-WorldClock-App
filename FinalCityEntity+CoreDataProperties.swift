//
//  FinalCityEntity+CoreDataProperties.swift
//  project3
//
//  Created by Kruthika Holla on 11/29/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

//saves city list after addition to display clock
import Foundation
import CoreData

extension FinalCityEntity {

    @NSManaged var cityArray: String?

}
