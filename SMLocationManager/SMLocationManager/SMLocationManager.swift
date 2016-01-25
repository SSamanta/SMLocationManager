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
    
    public func startStandardUpdate(handler :LocationHandler) {
        self.locationHandler =  handler
        self.locationManager.delegate = self
        self.trackLocationWithAuthorizationStatus()
    }
    //MARK: Location Manager Delegate
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = self.getRecentLocation(locations) {
            if self.locationHandler != nil {
                self.locationHandler!(location: location,error: nil)
            }
        }
    }
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
         if self.locationHandler != nil {
            self.locationHandler!(location: nil,error: error)
        }
    }
    //MARK: Stop Standard updates
    func stopStandardUpdates(){
        self.locationManager.stopUpdatingLocation()
    }
    //MARK: Authorization Delegate method
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        self.trackLocationWithAuthorizationStatus()
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
    func trackLocationWithAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            self.startLocationTracking()
        }else  if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    func startLocationTracking(){
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
    }
}
