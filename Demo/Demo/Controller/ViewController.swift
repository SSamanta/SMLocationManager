//
//  ViewController.swift
//  Demo
//
//  Created by Susim Samanta on 22/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import SMLocationManager
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var locationLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdated:", name: "kLocationUpdated", object: nil)
    }
    func locationUpdated(notification : NSNotification) {
        let locatinDict = notification.userInfo
        let location = locatinDict!["location"] as! CLLocation
        let locationDetails = "Speed : \(location.speed) m/s \nAltitude: \(location.altitude) m \nTime: \(location.timestamp) \nFloor: \(location.floor) \nHorizontal Accuracy : \(location.horizontalAccuracy) m"
        self.locationLabel.text = locationDetails
        SMLocationManager.getUserLocationAddress(location, handler: { (address, error) -> Void in
            let addressString = address! as String
            self.locationLabel.text = locationDetails + "\nAddress: " + addressString
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

