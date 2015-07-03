//
//  DistanceCalculator.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class DistanceCalculator: NSObject {
    var source : MKMapItem?
  
    
   var distance : [Double] = []

    
    var locationManager : CLLocationManager?
    
    
    
    func getDirections(destinationCoordiantes : [NSDictionary], sourceLatitude: String , sourceLongitude: String) {
        var i = 0
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        
        
        source = createMKMapItem(sourceLatitude, longitude: sourceLongitude)
    
        for destinationDict in destinationCoordiantes{
            i++
         var destinationLatitude = destinationDict.objectForKey("latitude") as! String
            var destinationLongitude = destinationDict.objectForKey("longitude") as! String
            
      var  destination = createMKMapItem(destinationLatitude, longitude: destinationLongitude)
        
        
        let request = MKDirectionsRequest()
        //        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setSource(source)
        request.setDestination(destination)
        
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                println(error)
            } else {
                
                for route in response.routes as! [MKRoute] {
                    
                    
                    var milesDistance = route.distance/1609.344
                  
                    var roundedMiles = Double(round(10*milesDistance)/10)
                    
                    self.distance.append(roundedMiles)
                    
                    println(roundedMiles)
                    
                }
            }
            
        })
    
            println("break")
        }
        
        
        }
    
   
    
    func createMKMapItem(latitude: String, longitude: String)-> MKMapItem{
    
       var latitudeDouble = (latitude as NSString).doubleValue
        var longitudeDouble = (longitude as NSString).doubleValue
        
        var coordinates = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble)
        var placeMark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var item = MKMapItem(placemark: placeMark)
        
        return item
    
    }
    
    
    
}