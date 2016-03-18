//
//  MiningData.swift
//  LocationDiary
//
//  Created by 1002541 on 2016. 3. 14..
//  Copyright © 2016년 1002541. All rights reserved.
//

import Foundation
import CoreData

protocol MiningProtocol {
    func fetchMinginData(miningList:[RefineData])
}

class MiningData {
    
    var delegate:MiningProtocol?
    
    func requestMinigData(dataList:[LDVisit]) {
        
        var list = [RefineData]()
        
        for data in dataList {
            
            print(data)
            
            if list.count == 0 {
                let miningSet = RefineData(data: data)
                list.append(miningSet)
            } else {
                
                var newData = true
                
                for item in list {
                    if item.inRegin(data) {
                        item.addData(data)
                        newData = false
                        break
                    }
                }
                
                if newData == true {
                    let miningSet = RefineData(data: data)
                    list.append(miningSet)
                }
            }
            
        }
        
        print(" \(dataList.count) - \(list.count)")
        delegate?.fetchMinginData(list)
    }
    
}