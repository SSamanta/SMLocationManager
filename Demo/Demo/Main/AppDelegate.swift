//
//  AppDelegate.swift
//  Demo
//
//  Created by Susim Samanta on 22/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import SMLocationManager
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if let options = launchOptions {
            if options[UIApplicationLaunchOptionsLocationKey] != nil {
                showLocalNotification("")
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdated:", name: "kLocationUpdated", object: nil)
            }
        }
        self.startTrackingLocation()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SMLocationManager.sharedInstance.startSignificantUpdate()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Configure Location Manager
    func startTrackingLocation(){
        SMLocationManager.sharedInstance.startStandardUpdate{(location, error) -> Void in
            let locationInfo = ["location" as NSObject:location as! AnyObject]
            NSNotificationCenter.defaultCenter().postNotificationName("kLocationUpdated", object: nil, userInfo: locationInfo)
        }
    }
    func locationUpdated(notification : NSNotification) {
        let locatinDict = notification.userInfo
        SMLocationManager.getUserLocationAddress(locatinDict!["location"] as! CLLocation, handler: { (address, error) -> Void in
            let addressString = address! as String
            self.showLocalNotification(addressString) // You can update address into your backend
        })
    }
    //MARK: show local notification 
    func showLocalNotification(body : String) {
        func checkLocalNotificationNeeded(location : CLLocation) {
            let localNotification : UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Your Location"
            localNotification.alertBody = body
            localNotification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
}

