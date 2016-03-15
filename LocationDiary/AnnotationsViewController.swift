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

class AnnotationsViewController: UIViewController, MKMapViewDelegate, MiningProtocol {

    @IBOutlet weak var mapView: MKMapView!
    
    var list = [RefineData]()
    
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
        let mining = MiningData()
        mining.delegate = self
        mining.requestMinigData(VisitDataManager.shardInstance.visits)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "pin")
        annView.pinTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        if let refineDataIndex = list.indexOf({
            let avg = $0.average()
            
            return avg.0 == annotation.coordinate.latitude && avg.1 == annotation.coordinate.longitude
        
        }) {
            print("\(refineDataIndex) / \(list.count)")
            
            let refinedData:RefineData = list[refineDataIndex]
            let count = refinedData.list.count
            
            print(" \(annotation.coordinate.latitude) and \(annotation.coordinate.longitude) in list \(refinedData.latitude) \(refinedData.longitude)  \(count)")
            switch count {
            case 1..<3 :
                annView.pinTintColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
            case 3..<6 :
                annView.pinTintColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)
            case 6..<10:
                annView.pinTintColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
            default:
                annView.pinTintColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
    
        } else {
            print(" \(annotation.coordinate.latitude) and \(annotation.coordinate.longitude) ")
        }
        return annView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = TWOGradientCircleRenderer(overlay: overlay)
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func fetchMinginData(miningList:[RefineData]) {
        list = miningList
        
        for item in list {
        
            let annotaionData = item.average()
            let location = CLLocationCoordinate2D(latitude: annotaionData.0, longitude: annotaionData.1 )
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(annotaionData.0, annotaionData.1)
            pin.title = "\(item.list.count)"
            mapView.addAnnotation(pin)
            let circle = MKCircle(centerCoordinate: location, radius: annotaionData.2 * 100000)
            mapView.addOverlay(circle)

        }
        
        if let item = list.last {
            
            let annotaionData = item.average()
            let regionRadius: CLLocationDistance = 500
            let location = CLLocationCoordinate2D(latitude: annotaionData.0, longitude:annotaionData.1)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
    }

}
