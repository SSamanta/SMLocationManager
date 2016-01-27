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
public typealias LocationAddressHandler = (address : String?,error: NSError?) -> Void

public class SMLocationManager: NSObject,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationHandler : LocationHandler?
    public static let sharedInstance = SMLocationManager()
    
    public func startStandardUpdate(handler :LocationHandler) {
        self.locationHandler =  handler
        self.locationManager.delegate = self
        self.trackLocationWithAuthorizationStatus()
    }
    public func startSignificantUpdate() {
        self.locationManager.startMonitoringSignificantLocationChanges()
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
    public func stopStandardUpdates(){
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
        if (abs(howRecent) < 15.0) {                             
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
    // MARK: Get formatted Address of Location
    public static func getUserLocationAddress(location : CLLocation, handler : LocationAddressHandler) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil {
                handler(address: nil,error: error)
            }else if placemarks?.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                var addressString = ""
                if let name = placemark.name {
                    addressString += name + ","
                }
                if let thoroughfare = placemark.thoroughfare {
                    addressString += thoroughfare + ","
                }
                if let subThoroughfare = placemark.subThoroughfare {
                    addressString += subThoroughfare + ","
                }
                if let locality = placemark.locality {
                    addressString += locality + ","
                }
                if let subLocality = placemark.subLocality {
                    addressString += subLocality
                }
                handler(address: addressString, error: nil)
            }else {
                handler(address: nil, error: nil)
            }
        }
    }
}
