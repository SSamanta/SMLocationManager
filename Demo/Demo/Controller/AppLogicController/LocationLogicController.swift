//
//  LocationLogicController.swift
//  Demo
//
//  Created by Susim Samanta on 27/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import CoreLocation

class LocationLogicController: NSObject {
    var latestValidLocation : CLLocation?
    
    func getValidLocation(location : CLLocation)-> CLLocation? {
        if location.horizontalAccuracy < 3000 {
            if latestValidLocation != nil {
                let timeDifference = location.timestamp.timeIntervalSinceDate(self.latestValidLocation!.timestamp)
                if timeDifference > 10 {
                    self.latestValidLocation = location
                    return self.latestValidLocation
                }
            }else {
                self.latestValidLocation = location
                return self.latestValidLocation
            }
        }
        return nil
    }
}
