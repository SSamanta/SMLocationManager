//
//  ViewController.swift
//  Demo
//
//  Created by Susim Samanta on 22/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import SMLocationManager

class ViewController: UIViewController {
    @IBOutlet weak var locationLabel : UILabel!
    let locationManager = SMLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.startStandardUpdate {[weak self](location, error) -> Void in
            if self != nil {
                SMLocationManager.getUserLocationAddress(location!, handler: { (address, error) -> Void in
                    let addressString = address! as String
                   self?.locationLabel.text = addressString
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

