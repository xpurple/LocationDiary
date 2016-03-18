//
//  DetailViewController.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 22..
//  Copyright © 2016년 1002541. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var visit:LDVisit?

    let regionRadius: CLLocationDistance = 500
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if visit != nil {
            let location = CLLocation(latitude: visit!.latitude, longitude: visit!.longitude)
            centerMapOnLocation(location)
            
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(visit!.latitude, visit!.longitude)
            pin.title = "여기"
            mapView.addAnnotation(pin)
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}