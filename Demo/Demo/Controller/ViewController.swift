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

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = SMLocationManager()
        locationManager.startStandardUpdated { (location, error) -> Void in
            print(location)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

