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
    
    func setVisit(visitData:LDVisit) {
        
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "ko_kr")
        format.timeZone = NSTimeZone(name: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let arrivalTime = "도착 : \(format.stringFromDate(visitData.arrivalDate))"
        let departureTime = "출발 : \(format.stringFromDate(visitData.departureDate))"

        arrivalDateLabel.text = arrivalTime
        depatureDateLabel.text = departureTime
        
        latitudeLabel.text = "latitude : \(visitData.latitude)"
        longitudeLabel.text = "longitude : \(visitData.longitude)"
        
    }

}
