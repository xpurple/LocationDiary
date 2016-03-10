//
//  AnnotationsViewController.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 26..
//  Copyright © 2016년 1002541. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TWOGradientCircleRenderer: MKCircleRenderer {
    
    override func fillPath(path: CGPath, inContext context: CGContext) {
        let rect:CGRect = CGPathGetBoundingBox(path)
        
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        let gradientLocations: [CGFloat]  = [0.6, 1.0];
        let gradientColors: [CGFloat] = [1.0, 1.0, 1.0, 0.25, 0.0, 1.0, 0.0, 0.25];
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, gradientLocations, 2);
        
        let gradientCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        let gradientRadius = min(rect.size.width, rect.size.height) / 2;
        
        CGContextDrawRadialGradient(context, gradient, gradientCenter, 0, gradientCenter, gradientRadius, .DrawsAfterEndLocation);
    }
}

class AnnotationsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var list = [NSManagedObject]()
    var annotaions = [Visit]()
    var ceilValue = 1000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        VisitDataManager.shardInstance.fetchVisits()
        list = VisitDataManager.shardInstance.visits
        
        for visit in list {
            let latitude :Double = ceil( (visit.valueForKey("latitude") as! NSNumber ).doubleValue * ceilValue) / ceilValue
            let longitude :Double = ceil( (visit.valueForKey("longitude") as! NSNumber ).doubleValue * ceilValue) / ceilValue
            let accuracy :Double = (visit.valueForKey("horizontalAccuracy") as! NSNumber).doubleValue
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude )
            print(" \(latitude)")
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            mapView.addAnnotation(pin)
            let circle = MKCircle(centerCoordinate: location, radius: accuracy)
            mapView.addOverlay(circle)
            
        }
        
        if let visit = list.last {
            let regionRadius: CLLocationDistance = 500
            let location = CLLocationCoordinate2D(latitude: (visit.valueForKey("latitude") as! NSNumber ).doubleValue, longitude: (visit.valueForKey("longitude") as! NSNumber ).doubleValue)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = TWOGradientCircleRenderer(overlay: overlay)
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
