//
//  VisitDataManager.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 22..
//  Copyright © 2016년 1002541. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreLocation

class VisitDataManager {
    static let shardInstance = VisitDataManager()
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var visits = [NSManagedObject]()
    
    func saveVisit(visit :LDVisit) {

        let entity = NSEntityDescription.entityForName("Visit", inManagedObjectContext: managedContext)
        let visitData = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        visitData.setValue(visit.arrivalDate, forKey: "arrivalDate")
        visitData.setValue(visit.departureDate, forKey: "departureDate")
        visitData.setValue(visit.horizontalAccuracy, forKey: "horizontalAccuracy")
        visitData.setValue(visit.latitude, forKey: "latitude")
        visitData.setValue(visit.longitude, forKey: "longitude")
        
        do {
            try managedContext.save()
            visits.append(visitData)
            
        } catch let error as NSError {
            let alert = UIAlertController(title:"저장할 수 없습니다!", message:error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in }
            alert.addAction(action)
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewController?.presentViewController(alert, animated: true, completion: { _ in })
        }
    }
    
    func fetchVisits()->[LDVisit] {

        var visitList = [LDVisit]()
        
        let fetchRequest = NSFetchRequest(entityName: "Visit")
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            visits = result as! [NSManagedObject]
            
            for visit in visits {
                visitList.append(LDVisit(visit:visit))
            }
            
            return visitList
            
        } catch let error as NSError {
            let alert = UIAlertController(title:"불러올 수 없습니다!", message:error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in }
            alert.addAction(action)
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewController?.presentViewController(alert, animated: true, completion: { _ in })
        }
        
        return [LDVisit]()
    }
    
    func deleteVisit(index:Int, completeHandler:()->()) {
        managedContext.deleteObject(visits[index] as NSManagedObject)
        visits.removeAtIndex(index)
        try! managedContext.save()
        completeHandler()
    }
}