//
//  Visit+CoreDataProperties.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 22..
//  Copyright © 2016년 1002541. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Visit {

    @NSManaged var arrivalDate: NSDate?
    @NSManaged var departureDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var horizontalAccuracy: NSNumber?

}
