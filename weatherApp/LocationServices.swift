//
//  LocationServices.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import CoreLocation



class LocationServices {
    
    private var locationManager = CLLocationManager()
    private var reverseGeoCoder = CLGeocoder()
    
    
    
    func getCurrentLocation(completion : (CLLocation?,String?) -> () )  {
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            if let currentLocation = locationManager.location {
               
                self.geoCodeLocation(currentLocation, completion: { (address) in
                    
                    if address != nil {
                         completion(currentLocation,address)
                    }
                    else{
                        print("could not geocode")
                        completion(currentLocation,nil)
                    }
                })
                
            }
            else{
                print("authrorized but location services off")
                completion(nil,nil)
            }
        }
        else{
            print("not authorized")
            completion(nil,nil)
        }
    }
    
    private func geoCodeLocation(currentLocation : CLLocation,completion : (String?) -> ()) {
        
        reverseGeoCoder.reverseGeocodeLocation(currentLocation) { (address, error) in
            if error ==  nil {
                if let locality = address?.first?.locality, let subLocality = address?.first?.subLocality {
                completion((subLocality) + "," + (locality))
                }
            }
            else{
                completion(nil)
            }
        }
    }
}