//
//  SMLocationManager.swift
//  SMLocationManager
//
//  Created by Susim Samanta on 22/01/16.
//  Copyright © 2016 Susim Samanta. All rights reserved.
//

import UIKit
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public typealias LocationHandler = (_ location : CLLocation?,_ error: NSError?) -> Void
public typealias LocationAddressHandler = (_ address : String?,_ error: NSError?) -> Void

open class SMLocationManager: NSObject,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationHandler : LocationHandler?
    open static let sharedInstance = SMLocationManager()
    
    open func startStandardUpdate(_ handler :@escaping LocationHandler) {
        self.locationHandler =  handler
        self.locationManager.delegate = self
        self.trackLocationWithAuthorizationStatus()
    }
    open func startSignificantUpdate() {
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    //MARK: Location Manager Delegate
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = self.getRecentLocation(locations) {
            if self.locationHandler != nil {
                self.locationHandler!(location,nil)
            }
        }
    }
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         if self.locationHandler != nil {
            self.locationHandler!(nil,error as NSError?)
        }
    }
    //MARK: Stop Standard updates
    open func stopStandardUpdates(){
        self.locationManager.stopUpdatingLocation()
    }
    //MARK: Authorization Delegate method
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        self.trackLocationWithAuthorizationStatus()
    }
    //MARK: If it's a relatively recent event, turn off updates to save power.
    func getRecentLocation(_ locations :[CLLocation]) -> CLLocation? {
        let location = locations.last! as CLLocation
        let eventDate = location.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        if (abs(howRecent) < 15.0) {                             
           return location
        }
        return nil
    }
    func trackLocationWithAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.startLocationTracking()
        }else  if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    func startLocationTracking(){
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.startUpdatingLocation()
    }
    // MARK: Get formatted Address of Location
    open static func getUserLocationAddress(_ location : CLLocation, handler : @escaping LocationAddressHandler) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil {
                handler(nil,error as NSError?)
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
                handler(addressString, nil)
            }else {
                handler(nil, nil)
            }
        }
    }
}
