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
        SMLocationManager.getUserLocationAddress(locatinDict!["location"] as! CLLocation, handler: { (address, error) -> Void in
            let addressString = address! as String
            self.locationLabel.text = addressString
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

