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
    
    var list = [LDVisit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LocationManager.sharedInstance.serviceOn()
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
        list.removeAll()
        list.appendContentsOf(VisitDataManager.shardInstance.fetchVisits())

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! MapDataCell
        let visit = list[indexPath.row]
        cell.setVisit(visit)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowVisitDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            VisitDataManager.shardInstance.deleteVisit(indexPath.row, completeHandler: {() -> () in
                self.reloadData()
            })
        }
    }
    
    @IBAction func pressAdd(sender: UIBarButtonItem) {
        
        if let location = LocationManager.sharedInstance.currentLocation() {
            VisitDataManager.shardInstance.saveVisit(location)
            
            reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVisitDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            if let indexPath:NSIndexPath = sender as? NSIndexPath {
                detailViewController.visit = list[indexPath.row]
            }
        }
        
    }
    
}

