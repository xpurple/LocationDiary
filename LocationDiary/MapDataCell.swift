//
//  MapDataCell.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 3. 10..
//  Copyright © 2016년 1002541. All rights reserved.
//

import UIKit
import CoreData

class MapDataCell: UITableViewCell {

    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var depatureDateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setVisit(visitData:NSManagedObject) {
        
        var arrivalTime = "도착 : 없음"
        var departureTime = "출발 : 없음"
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "ko_kr")
        format.timeZone = NSTimeZone(name: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = visitData.valueForKey("arrivalDate") as? NSDate {
            arrivalTime = "도착 : \(format.stringFromDate(date))"
        }
        
        if let date = visitData.valueForKey("departureDate") as? NSDate {
            departureTime = "출발 : \(format.stringFromDate(date))"
        }
        
        arrivalDateLabel.text = arrivalTime
        depatureDateLabel.text = departureTime
        
        latitudeLabel.text = "latitude : \(visitData.valueForKey("latitude") as! NSNumber)"
        longitudeLabel.text = "longitude : \(visitData.valueForKey("longitude") as! NSNumber)"
        
    }

}
