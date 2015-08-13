//
//  CitiesModel.swift
//  Cities
//
//  Created by g216 DIT UPM on 18/12/14.
//  Copyright (c) 2014 g216 DIT UPM. All rights reserved.
//

import Foundation

class CitiesModel {
    
    var cities : [String]
    
    init() {
        
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")!
        
        cities = NSArray(contentsOfFile: path) as [String]
        
    }

}