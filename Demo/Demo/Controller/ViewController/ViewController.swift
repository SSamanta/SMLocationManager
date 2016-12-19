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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.locationUpdated(_:)), name: NSNotification.Name(rawValue: "kLocationUpdated"), object: nil)
    }
    func locationUpdated(_ notification : Notification) {
        let locatinDict = notification.userInfo
        let location = locatinDict!["location"] as! CLLocation
        let locationDetails = "Speed : \(location.speed) m/s \nAltitude: \(location.altitude) m \nTime: \(location.timestamp) \nFloor: \(location.floor) \nHorizontal Accuracy : \(location.horizontalAccuracy) m"
        SMLocationManager.getUserLocationAddress(location, handler: { (address, error) -> Void in
            let addressString = address! as String
            self.locationLabel.text = locationDetails + "\nAddress: " + addressString
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

