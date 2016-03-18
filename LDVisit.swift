//
//  LDVisit.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 3. 18..
//  Copyright © 2016년 1002541. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

struct LDVisit {
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var horizontalAccuracy:Double = 0.0
    var arrivalDate:NSDate = NSDate(timeIntervalSince1970: 0)
    var departureDate:NSDate = NSDate(timeIntervalSince1970: 0)
    
    init(visit:NSManagedObject) {
        latitude = visit.valueForKey("latitude")!.doubleValue
        longitude = visit.valueForKey("longitude")!.doubleValue
        horizontalAccuracy = visit.valueForKey("horizontalAccuracy")!.doubleValue
        arrivalDate = visit.valueForKey("arrivalDate") as! NSDate
        departureDate = visit.valueForKey("departureDate") as! NSDate
    }
    
    init(useCLVisit:CLVisit) {
        latitude = useCLVisit.coordinate.latitude
        longitude = useCLVisit.coordinate.longitude
        horizontalAccuracy = useCLVisit.horizontalAccuracy
        arrivalDate = useCLVisit.arrivalDate
        departureDate = useCLVisit.departureDate
    }
    
    init(currentLocation:CLLocation) {
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        horizontalAccuracy = currentLocation.horizontalAccuracy
        arrivalDate = NSDate()
        departureDate = NSDate()
    }
    
    func coordinate()->CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
}