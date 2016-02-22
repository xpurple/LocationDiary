//
//  LocationManager.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 18..
//  Copyright © 2016년 1002541. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreData

class LocationManager :NSObject, CLLocationManagerDelegate {
    
    static var sharedInstance = LocationManager()
    
    lazy var location: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        m.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        m.allowsBackgroundLocationUpdates = true
        return m
    }()
    
    func serviceOn() {
        if (CLLocationManager.authorizationStatus() != .AuthorizedAlways) {
            
            let alert = UIAlertController(title:"경고!", message:"위치정보를 가져올 수 있도록 설정해 주세요", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { _ in
                self.location.requestAlwaysAuthorization()
            }
            alert.addAction(action)
            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewController?.presentViewController(alert, animated: true, completion: { _ in })

        } else {
            start()
        }
    }
    
    func start() {
        location.startUpdatingLocation()
        location.startMonitoringVisits()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case CLAuthorizationStatus.AuthorizedAlways = status {
            start()
        } 
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //
    }
    
    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
        //
        VisitDataManager.shardInstance.saveVisit(visit)
    }
    
    func currentLocation() -> TempVisit? {
        
        let visit = TempVisit()
        
        if let current = location.location {
            visit.longitude = NSNumber(double: current.coordinate.longitude)
            visit.latitude = NSNumber(double: current.coordinate.latitude)
            visit.horizontalAccuracy = NSNumber(double: current.horizontalAccuracy)
            visit.arrivalDate = NSDate();
            visit.departureDate = NSDate();
            
            return visit
        } else {
            return nil;
        }
    }
}
