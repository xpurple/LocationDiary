//
//  refineData.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 3. 14..
//  Copyright © 2016년 1002541. All rights reserved.
//

import Foundation
import CoreData

class RefineData {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var list = [NSManagedObject]()
    let volume = 1000.0
    
    init (data:NSManagedObject) {
        let dataLatitude = data.valueForKey("latitude")!.doubleValue
        let dataLongitude = data.valueForKey("longitude")!.doubleValue
        
        latitude = ceil(dataLatitude * volume)
        longitude = ceil(dataLongitude * volume)
        
        addData(data)
    }
    
    func inRegin(data:NSManagedObject) -> Bool {
        
        let dataLatitude = data.valueForKey("latitude")!.doubleValue
        let dataLongitude = data.valueForKey("longitude")!.doubleValue
        
        if latitude == ceil(dataLatitude * volume) && longitude == ceil(dataLongitude * volume) {
            return true
        }

        return false
    }
    
    func addData(data:NSManagedObject) {
        list.append(data)
    }
    
    func average()->(latitude:Double, longitude:Double, deviation:Double) {
        
        let count = list.count
        var sumLatidue: Double = 0
        var sumLongitude: Double = 0
        
        for item in list {
            sumLatidue += item.valueForKey("latitude")!.doubleValue
            sumLongitude += item.valueForKey("longitude")!.doubleValue
        }
        
        let averageLocationX = sumLatidue / Double(count)
        let averageLocationY = sumLongitude / Double(count)
        
        var varianceSum:Double = 0
        
        for item in list {
            varianceSum = variance( averageLocationX, x2: item.valueForKey("latitude")!.doubleValue, y1: averageLocationY, y2: item.valueForKey("longitude")!.doubleValue )
        }
        
        return (averageLocationX , averageLocationY, varianceSum / Double(count))
    }
    
    func variance(x1:Double, x2:Double, y1:Double, y2:Double)->Double {
        return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }
}