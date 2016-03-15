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
    
    var visits = [NSManagedObject]()
    
    func saveVisit(visit :CLVisit) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Visit", inManagedObjectContext: managedContext)
        let visitData = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        visitData.setValue(visit.arrivalDate, forKey: "arrivalDate")
        visitData.setValue(visit.departureDate, forKey: "departureDate")
        visitData.setValue(visit.horizontalAccuracy, forKey: "horizontalAccuracy")
        visitData.setValue(visit.coordinate.latitude, forKey: "latitude")
        visitData.setValue(visit.coordinate.longitude, forKey: "longitude")
        
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
    
    func saveCurrentLocation(visit :TempVisit) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
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
    
    func fetchVisits() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Visit")
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            visits = result as! [NSManagedObject]
        } catch let error as NSError {
            let alert = UIAlertController(title:"불러올 수 없습니다!", message:error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in }
            alert.addAction(action)
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewController?.presentViewController(alert, animated: true, completion: { _ in })
        }
    }
    
    func deleteVisit(index:Int, completeHandler:()->()) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(visits[index] as NSManagedObject)
        visits.removeAtIndex(index)
        try! managedContext.save()
        completeHandler()
    }
    
    func miningVisit(volume:Double, completeHandler:([TempVisit])->()) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Visit")
        fetchRequest.resultType = .DictionaryResultType
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            visits = result as! [NSManagedObject]
            
            var list = [TempVisit]()
            
            for data in result {
                
                let dataLatitude :Double = (data.valueForKey("latitude") as! NSNumber ).doubleValue
                let dataLongitude :Double = (data.valueForKey("longitude") as! NSNumber ).doubleValue
                
                for item in list {
                
                    guard let x1 = item.latitude?.doubleValue else { continue }
                    guard let y1 = item.longitude?.doubleValue else { continue }
                    
                    if (x1 - volume < dataLatitude &&  dataLatitude < x1 + volume) && (y1 - volume < dataLongitude && dataLongitude < y1 + volume) {
                        
                    }
                    
                    
                }
                let tempVisit = TempVisit()
                list.append(tempVisit)
                
            }
            
            completeHandler(list)
            
        } catch let error as NSError {
            let alert = UIAlertController(title:"불러올 수 없습니다!", message:error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in }
            alert.addAction(action)
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewController?.presentViewController(alert, animated: true, completion: { _ in })
        }
        
//        // count
//        let countExpression = NSExpression(format: "count:(*)")
//        let countExpressionDescription = NSExpressionDescription()
//        countExpressionDescription.expression = countExpression
//        countExpressionDescription.name = "countData"
//        countExpressionDescription.expressionResultType = .Integer64AttributeType
        
        // round latitude
//        let latitudeField = NSExpression(forKeyPath: "latitude")
////        let ceilingPosition = NSExpression(forConstantValue: "3")
//        let roundLatitudeExpression = NSExpression.init(forFunction: "abs:", arguments: [latitudeField])
//        let roundLatitudeExpressionDescription = NSExpressionDescription()
//        roundLatitudeExpressionDescription.expression = roundLatitudeExpression
//        roundLatitudeExpressionDescription.name = "latitude"
//        roundLatitudeExpressionDescription.expressionResultType = .DoubleAttributeType
//        
//        // round longitude
//        let longitudeField = NSExpression(forKeyPath: "longitude")
//        let roundLongitudeExpression = NSExpression.init(forFunction: "floor:", arguments: [longitudeField])
//        let roundLongitudeExpressionDescription = NSExpressionDescription()
//        roundLongitudeExpressionDescription.expression = roundLongitudeExpression
//        roundLongitudeExpressionDescription.name = "longitude"
//        roundLongitudeExpressionDescription.expressionResultType = .DoubleAttributeType
//        
//        fetchRequest.propertiesToFetch = [roundLatitudeExpressionDescription, roundLongitudeExpressionDescription]
//        //fetchRequest.propertiesToGroupBy = [roundLatitudeExpressionDescription, roundLongitudeExpressionDescription]
//        
//        do {
//        let result = try managedContext.executeFetchRequest(fetchRequest)
//            for record in result {
//                print(record)
//            }
//        } catch {
//            let empty = [TempVisit]()
//            completeHandler(empty)
//        }
    }
}