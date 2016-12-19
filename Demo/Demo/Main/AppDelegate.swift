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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let options = launchOptions {
            if options[UIApplicationLaunchOptionsKey.location] != nil {
                showLocalNotification("")
                NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.locationUpdated(_:)), name: NSNotification.Name(rawValue: "kLocationUpdated"), object: nil)
            }
        }
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil))
        self.startTrackingLocation()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SMLocationManager.sharedInstance.stopStandardUpdates()
        SMLocationManager.sharedInstance.startSignificantUpdate()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        self.startTrackingLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Configure Location Manager
    func startTrackingLocation(){
        let logic = LocationLogicController()
        SMLocationManager.sharedInstance.startStandardUpdate{(location, error) -> Void in
            if location != nil {
                if logic.getValidLocation(location!) != nil {
                    let locationInfo = ["location" as NSObject:location as! AnyObject]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "kLocationUpdated"), object: nil, userInfo: locationInfo)
                }
                
            }
        }
    }
    func locationUpdated(_ notification : Notification) {
        let locatinDict = notification.userInfo
        let location = locatinDict!["location"] as! CLLocation
        let locationDetails = "Speed : \(location.speed) m/s \nAltitude: \(location.altitude) m \nTime: \(location.timestamp) \nFloor: \(location.floor) \nHorizontal Accuracy : \(location.horizontalAccuracy) m"
        SMLocationManager.getUserLocationAddress(location, handler: { (address, error) -> Void in
            let addressString = "Address : \(address! as String)"
            self.showLocalNotification(locationDetails+addressString) // You can update address into your backend
        })
    }
    //MARK: show local notification 
    func showLocalNotification(_ body : String) {
        let localNotification : UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Your Location"
        localNotification.alertBody = body
        localNotification.fireDate = Date()
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}

