//
//  ViewController.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    
    var locationArray : [Location]?
    var customAnnotations = [CustomAnnotation]()
    var annotationImages : [String] = []
    var presentAnnotationImage :[String] = []
    var success = false
    var latitudes : [Double] = []
    var longitudes: [Double] = []
    var distances : [Double] = []
    // setting current latitude
    let currentLatitude = "38.9306"
    let currentLongitude = "-77.0709"
    var distanceCoordinates : [NSDictionary] = []
    //images used for loading animation
    var preloaderImages = ["Preloader 01.png", "Preloader 02.png", "Preloader 03.png", "Preloader 04.png"]
    
    var indexPath : NSIndexPath?
    
    let counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFile()
        addCoordinatesToAnnotation()

        
 
        
        
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    func getDataFromFile(){
    
    
        let url = NSBundle.mainBundle().URLForResource("LocationData", withExtension: ".json")
        
        API.getData(url!) { (succeeded: Bool, msg: NSDictionary) -> () in
            
            //placeholder styling
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                
                if(succeeded){
                    
                    if  let data = msg.objectForKey("value") as? NSArray{
                    
                        // converting json into location object
                    var locationObj = Location()
                    self.locationArray = locationObj.parseLocations(data)
                        //retrieving and converting latitudes and longitudes to "double" and appending it to arrays
                        self.parseCoordinates()
                        
                        
                        // presenting the annotations
                        for(var i=0; i<self.locationArray!.count; i++){
                            // presentAnnotationImage.append(array[i].getWaitTime())
                            
                            var tipImage = "Icn_Location_Tip.png"
                            self.annotationImages.append(tipImage)
                            
                            var waitImage = "Icn_Location_Tip Copy.png"
                            self.presentAnnotationImage.append(waitImage)
                        }
                        
                        
                       
                            
                        
                        

                    }
                }else{

                    var alertMessage = msg.objectForKey("value") as? String
                    var alertTitle = NSLocalizedString("errorConnectionTitle", comment: "Title for error")
                    var alertButton = NSLocalizedString("alertButtonTitle", comment: "Button title for alert")

                        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: alertButton, style: .Default) { (action) in
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) {
  
                    }
                    
                }
                
                self.collectionView.reloadData()

                
                
            })
        }
    }
    
    
// collection view delegate and data source methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCellIdentifier", forIndexPath: indexPath) as! CollectionViewTableCell

        if let array = locationArray{
            
            
            if(indexPath.row == 0){
            self.indexPath = indexPath
            }
            
            let locationObj = array[indexPath.row]
            
            // delegating the names and images to collection view
            cell.locationNameLabel.text  = locationObj.getLocationName()
            
            let image = UIImage(named: locationObj.getLocationImageName())
            cell.locationImageView.image = image
            
            // rounded border for view
            
            let view = cell.cssView
//            view.backgroundColor = UIColor( red: 235/255, green: 244/255, blue: 255/255, alpha: 1)
//            view.layer.cornerRadius = 5
//            view.layer.borderColor = UIColor( red: 235/255, green: 244/255, blue: 255/255, alpha: 1).CGColor
//            view.layer.borderWidth = 0.5
            
                        view.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
                        view.layer.cornerRadius = 5
                        view.layer.borderColor = UIColor( red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0).CGColor
                        view.layer.borderWidth = 0.5
            
            
            cell.latitude = locationObj.getLatitude()
            cell.longitude = locationObj.getLongitude()
            
            
            // animation effect and showing the distance
            if (distances.count == locationArray!.count ){
                
                var string = self.distances[indexPath.row]
                
               
                
                cell.animationView.hidden = true
                cell.locationDistanceLabel.hidden = false
                cell.locationDistanceLabel.text = "\(string) miles"
                
            }else if(distances.count == 0){
                
                cell.locationDistanceLabel.hidden = true
                
                
                // loading animation
                var imagesList : [UIImage] = []
                
                for image in preloaderImages
                {
                    
                    var image  = UIImage(named:image)
                    imagesList.append(image!)
                }
                
                cell.animationView.animationImages = imagesList;
                cell.animationView.animationDuration = 1.0
                cell.animationView.startAnimating()
                
            }

           
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let array = locationArray{
        
        return array.count
        }
        else{
        
        return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        return CGSizeMake(screenWidth, 76.0)    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 20
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        mapView.removeAnnotations(mapView.annotations)
        
        let indexPath =   collectionView.indexPathsForVisibleItems()
        
        self.indexPath = indexPath[0] as?  NSIndexPath
        // delegating the var waittimearray to var waittime
        
//        self.waitTime = waitTimeString[indexPath[0].row]
        
        if let array = locationArray{
            
            for (var i=0 ;i<array.count;i++){
                if(i == indexPath[0].row){
                    customAnnotations[i].imageName = presentAnnotationImage[i]
                }
                else{
                    customAnnotations[i].imageName = annotationImages[i]
                }
            }
        }
        
        zoomToFitMapAnnotations(customAnnotations)
    }
    
    //distance calculation methods
    func getDistance(coordinates: [NSDictionary]){
        
        var distanceCalculator = DistanceCalculator()
        
        //      distanceCalculator.getDirections(coordinates,sourceLatitude: "32.9",sourceLongitude: "-96.5")
        
        distanceCalculator.getDirections(coordinates,sourceLatitude: currentLatitude,sourceLongitude: currentLongitude)
        
        delayTimer(distanceCalculator)
        
    }
    
    
    func delayTimer(obj: DistanceCalculator){
        
        
        if(obj.distance.count < locationArray!.count){
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.delayTimer(obj)
            }
            
        }else{
            
            for (var i=0; i<locationArray!.count; i++){
                
                
                var roundedDecimal = Double(round(1000*obj.distance[i])/1000)
                
                distances.append(roundedDecimal)
                
                
                
                println (distances.count)
                
                if(distances.count == locationArray!.count){
                    
                    collectionView.reloadData()
                }
                
            }
            
//            sharedSingletonData.singletonDistances = distances
            
        }
    }

    
    
//annotation methods
    func zoomToFitMapAnnotations(customAnnot: [CustomAnnotation]){
        var topLeftCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        var bottomRightCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        var foundAnotation = false;
        
        var waitImageAnnotation : CustomAnnotation?
        

        
        for anotation in customAnnot{
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, anotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, anotation.coordinate.latitude);
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, anotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, anotation.coordinate.latitude);
            
            mapView.addAnnotation(anotation);
            
            foundAnotation = true;
        }
        
        
        if(!foundAnotation){
            return;
        }
        
        var region:MKCoordinateRegion = MKCoordinateRegion(center: topLeftCoord, span:MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0));
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 3;
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 3;
        
        mapView.regionThatFits(region);
        mapView.setRegion(region, animated: true);
        
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
        
        
        //adding waittime text
//        if( cpa.imageName == "Path.png"){
//            for subview in anView.subviews {
//                //                if !(subview is UILayoutSupport) {
//                subview.removeFromSuperview()
//            }
//            addTextToAnnotation(anView, waitTime: self.waitTime!)
//        }
//        else{
//            // removing text from other annotations
//            for subview in anView.subviews {
//                //                if !(subview is UILayoutSupport) {
//                subview.removeFromSuperview()
//            }
//        }
      return anView
    }
    

    func addCoordinatesToAnnotation(){
        if(success == false){
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.addCoordinatesToAnnotation()
            }            }
            
        else{
            for (var i=0;i<latitudes.count;i++) {
                let customAnnotation = CustomAnnotation()
                
                if(i==0){
                    customAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]);
                    customAnnotation.imageName = presentAnnotationImage[i]
                    customAnnotation.title = ""
                    self.customAnnotations.append(customAnnotation)}
                else{
                    customAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]);
                    customAnnotation.imageName = annotationImages[i]
                    customAnnotation.title = ""
                    self.customAnnotations.append(customAnnotation)
                    
                }
            }
            zoomToFitMapAnnotations(customAnnotations)
        }
    }
    
    func parseCoordinates(){
        
        if let array = locationArray{
            for (var i=0; i<array.count; i++){
                
                var locationObj  = array[i]
                
                var latitude  = locationObj.getLatitude()
                
                var numberFormatter = NSNumberFormatter()
                var number :Double = Double(numberFormatter.numberFromString(latitude)!)
                
                self.latitudes.append(number)

                
                var longitude  = locationObj.getLongitude()
                
                var longitudeNumberFormatter = NSNumberFormatter()
                var longitudeNumber :Double = Double(numberFormatter.numberFromString(longitude)!)
                
                self.longitudes.append(longitudeNumber)
                var dict = ["latitude":"\(number)", "longitude":"\(longitudeNumber)"]
                
                self.distanceCoordinates.append(dict)
                
                
            }
            
            
            self.getDistance(self.distanceCoordinates)
            self.success = true
        }
        
    }
    func createMapItem(destLat: String, destLong: String)-> MKMapItem{
        
        var latitude = (destLat as NSString).doubleValue
        var longitude = (destLong as NSString).doubleValue
        
        var coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        var placeMark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var destination = MKMapItem(placemark: placeMark)
        
        
        return destination
    }
    



    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DirectionsIdentifier"{
        
        let destinationController = segue.destinationViewController as! DirectionsViewController
            
            var cell = collectionView.cellForItemAtIndexPath(self.indexPath!) as! CollectionViewTableCell
            
            
            
            
            destinationController.sourceMapItem = self.createMapItem(currentLatitude, destLong: currentLongitude)
            destinationController.destinationMapItem = self.createMapItem(cell.latitude!, destLong: cell.longitude!)
        
        }
    }
    
 

    
}

