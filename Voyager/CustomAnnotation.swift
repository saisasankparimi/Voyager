//
//  CustomAnnotation.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation:NSObject, MKAnnotation {
    var imageName: String;
    var coordinate:CLLocationCoordinate2D;
    var title:String;
    override init() {
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        self.imageName = ""
        self.title = ""
    }
    
    
    
}
