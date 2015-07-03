//
//  DirectionsViewController.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 7/2/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit
import MapKit


class DirectionsViewController: UIViewController {

    @IBOutlet weak var routeMapView: MKMapView!

    var customImageAnnotations : [CustomAnnotation] = [CustomAnnotation]()
    var currentLocation : CLLocation?
    
    var destinationLatitude : String?
    var destinationLongitude : String?
    
    var sourceMapItem : MKMapItem?
    var destinationMapItem : MKMapItem?
    
    var directionsFailed  = false
    var zoomedOnce        = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCoordinatesToAnnotation()
            self.getDirections()
    }

    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.setSource(sourceMapItem!)
        request.setDestination(destinationMapItem!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                    println("error in getting directions")

                           } else {
                self.showRoute(response)
                          }
        })
    }
    
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as! [MKRoute] {
            
            routeMapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                println(step.instructions)
            }
        }
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor(red: 23/255, green: 143/255, blue: 230/255, alpha: 1)
            renderer.lineWidth = 5.0
            return renderer
    }
    
//    //annotation methods
    func zoomToFitMapAnnotations(customAnnot: [CustomAnnotation]){
       
        var foundAnotation = false;
        var waitImageAnnotation : CustomAnnotation?

        for anotation in customAnnot{

            
            routeMapView.addAnnotation(anotation);
            
            foundAnotation = true;
        }
        
        
        if(!foundAnotation){
            return;
        }
        
        
      var userLoc = CLLocation(latitude: sourceMapItem!.placemark.coordinate.latitude, longitude: sourceMapItem!.placemark.coordinate.latitude)
        var dest = CLLocation(latitude: destinationMapItem!.placemark.coordinate.latitude, longitude: destinationMapItem!.placemark.coordinate.longitude)
        
       var dist = userLoc.distanceFromLocation(dest)
         var center =  CLLocationCoordinate2DMake(sourceMapItem!.placemark.coordinate.latitude, sourceMapItem!.placemark.coordinate.longitude)
        
     var region =   MKCoordinateRegionMakeWithDistance(center, 10000,  10000)

       routeMapView.setRegion(region, animated: true);
        
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        let reuseId = "annotation"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        let cpa = annotation as! CustomAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        
        return anView
    }
    
    
    func addCoordinatesToAnnotation(){

                var customAnnotation = CustomAnnotation()
                
             
                    customAnnotation.coordinate = CLLocationCoordinate2D(latitude: sourceMapItem!.placemark.coordinate.latitude, longitude: sourceMapItem!.placemark.coordinate.longitude);
                    customAnnotation.imageName = ""
                    customAnnotation.title = ""
                    self.customImageAnnotations.append(customAnnotation)
        
                    customAnnotation.coordinate = CLLocationCoordinate2D(latitude: destinationMapItem!.placemark.coordinate.latitude, longitude: destinationMapItem!.placemark.coordinate.longitude);
                    customAnnotation.imageName = "mapannotation.png"
                    customAnnotation.title = ""
                    self.customImageAnnotations.append(customAnnotation)

            zoomToFitMapAnnotations(customImageAnnotations)
        }

  
}
