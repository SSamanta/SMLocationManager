//
//  SMLocationManager.swift
//  SMLocationManager
//
//  Created by Susim Samanta on 22/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import CoreLocation

public typealias LocationHandler = (location : CLLocation?,error: NSError?) -> Void

public class SMLocationManager: NSObject,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationHandler : LocationHandler?
    
    public func startStandardUpdated(handler :LocationHandler) {
        self.locationHandler =  handler
        self.locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization() 
        }
        locationManager.distanceFilter  = 500
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    //MARK: Location Manager Delegate
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = self.getRecentLocation(locations) {
            if locationHandler != nil {
                locationHandler!(location: location,error: nil)
            }
        }
    }
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
         if locationHandler != nil {
            locationHandler!(location: nil,error: error)
        }
    }
    //MARK: Stop Standard updates
    func stopStandardUpdates(){
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK: If it's a relatively recent event, turn off updates to save power.
    func getRecentLocation(locations :[CLLocation]) -> CLLocation? {
        let location = locations.last! as CLLocation
        let eventDate = location.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        if (abs(howRecent) < 1.0) {
           return location
        }
        return nil
    }
    
}
