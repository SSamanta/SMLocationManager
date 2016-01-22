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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = SMLocationManager()
        locationManager.startStandardUpdated {[weak self](location, error) -> Void in
            if self != nil {
                self!.locationLabel.text = "\(location) \(error)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

