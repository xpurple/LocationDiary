//
//  ViewController.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 2. 18..
//  Copyright © 2016년 1002541. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var list = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LocationManager.sharedInstance.serviceOn()
        reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadData() {
        VisitDataManager.shardInstance.fetchVisits()
        list = VisitDataManager.shardInstance.visits
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell")
        let visit = list[indexPath.row]
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "ko_kr")
        format.timeZone = NSTimeZone(name: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = visit.valueForKey("arrivalDate") as? NSDate {
        let time = format.stringFromDate(date)
            cell!.textLabel!.text = time
        } else {
            cell!.textLabel!.text = "없음"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let visit = list[indexPath.row] as? Visit {
            performSegueWithIdentifier("ShowVisitDetail", sender: visit)
        }
    }
    
    @IBAction func pressAdd(sender: UIBarButtonItem) {
        
        if let location = LocationManager.sharedInstance.currentLocation() {
            VisitDataManager.shardInstance.saveCurrentLocation(location)
            
            reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVisitDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.visit = sender as? Visit
        }
        
    }
    
}

