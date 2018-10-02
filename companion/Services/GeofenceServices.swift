//
//  GeofenceServices.swift
//  companion
//
//  Created by Yves Songolo on 10/2/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoFenceServices{
    
    
    /// method to convert address to coordinate
    static func addressToCoordinate(_ address: String, completion: @escaping(CLLocationCoordinate2D?)->()){
        print("getting location coordinate")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            
            if error != nil {return completion(nil)}
            
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            guard let longitude = lon, let latitutde = lat else {return completion(nil)}
            print("location: lat: \(latitutde) lon: \(longitude)")
            
            return completion(CLLocationCoordinate2D(latitude: latitutde, longitude: longitude))
            
        }
    }
    /// Mehtod to start monitoring region
    static func startMonitoringMakeschool(){
        let address = "555 post street, San Francisco, CA"
        addressToCoordinate(address) { (center) in
            
            guard let center = center else {return}
            
            let region = CLCircularRegion(center: center, radius: 150, identifier: "make school")
            let manager = CLLocationManager()
            manager.startMonitoring(for: region)
            
        }
    }
}








