//
//  Location.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit

class Location: NSObject {
   
    var locationName : String?
    var locationImageName : String?
    var latitude : String?
    var longitude : String?
    
    func locationIntializer(name: String, image : String, latitude: String, longitude: String) -> Location {
    
    self.locationName = name
    self.locationImageName = image
    self.latitude = latitude
    self.longitude   = longitude
        
     return self
    }
    
    
    func parseLocations(data : NSArray) -> [Location]{
    
         let json = JSON(data)
    
        var locationArray = [Location]()
        
        for dict in json.arrayValue as Array{
        
        let name = dict["locationName"].stringValue
        let imageName = dict["locationImage"].stringValue
        let latitude = dict["latitude"].stringValue
        let longitude = dict["longitude"].stringValue
            
           let locationObj = Location()
            
            locationObj.locationIntializer(name, image: imageName, latitude: latitude, longitude: longitude)
            locationArray.append(locationObj)
        }
        
        return locationArray
    }
    
    func getLocationImageName()->String{
        
        if let variable = locationImageName{
            return variable
        }
        return ""
    }
    
    func getLocationName()->String{
        
        if let variable = locationName{
            return variable
        }
        return ""
    }
    
    func getLatitude()->String{
        
        if let variable = latitude{
            return variable
        }
        return ""
    }
    
    func getLongitude()->String{
        
        if let variable = longitude{
            return variable
        }
        return ""
    }


}
