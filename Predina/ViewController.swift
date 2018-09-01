//
//  ViewController.swift
//  Predina
//
//  Created by Administrator on 06/08/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import UIKit
import MapKit




var VehicleOnRoad = [Vehicles]()
var mapHotspots = [hotspots]()
var i = 30  //
var min = 5
var sec = 0
class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    var gameTimer: Timer!
    var messageView : UIView?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
         self.mapView.delegate = self
        
   
         self.activity.startAnimating()
        
 
        DispatchQueue.global(qos: .background).async  //concurrent queue, shared by system
            {
                self.readCoordinates() //add cocordi
                self.readReatimeLocation() //add vehicles
                
                DispatchQueue.main.async //serial queue
                    {
                          self.addAnnotations()
                          self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                }
        }
       
        //gameTimer.invalidate()
        
    }
    
  

    
    func clearMap() {
        //remove annotattions
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        //remove overlays
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    
    func addHotSpots() {
        for hotspot in mapHotspots {
            
            //add circle
            let location = CLLocation(latitude: hotspot.latitude, longitude: hotspot.longitude)
            addRadiusCircle(location: location)
            
        }
    }
    
    func centerMapToPoint() {
        //center to map to point
        let  location2d =   CLLocationCoordinate2D(latitude: 51.49627778, longitude: -0.052388889)
        let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.9)  //0.8
        let region = MKCoordinateRegion(center: location2d, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    func addRadiusCircle(location: CLLocation){
       
        var circle = MKCircle(center: location.coordinate, radius: 500 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //  if overlay is MKCircle {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = randomColour()
        circle.fillColor = randomColour()
        circle.lineWidth = 1
        return circle
        //}
    }
    
    

    
    @objc func runTimedCode() {
          self.activity.stopAnimating()
        clearMap()
        centerMapToPoint()
        
        addHotSpots()
        addAnnotations()
    }
   
    func addAnnotations() {
        //add annotation
        let timeString = timeValue(i: i)
      //  print(timeString)
        
        let carpositions = VehicleOnRoad.filter{ $0.time == timeString}
       // print(carpositions.count)
        for carpos in carpositions {
            
            // let    carpos =  VehicleOnRoad[i]
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: carpos.latitude, longitude: carpos.Longitude)
            //annotation.title
            // DispatchQueue.main.async { [unowned self] in
            self.mapView.addAnnotation(annotation)
            // }
            
            
        }
        i += 1
        if i == 330 {  //set to run for first 30 sec
            i = 300
        }
    }
    
    func readCoordinates() {
        var data = readDataFromCSV(fileName: "Coordinates", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        for (index, _)in csvRows.enumerated() {
            print( "\(csvRows[index][0]) ,  \(csvRows[index][1])") //
            
            let point = hotspots(latitude: Double(csvRows[index][0]) ?? 0, longitude: Double(csvRows[index][1]) ?? 0)
            mapHotspots.append(point)
            if index == 1000 {
                break
            }
        }
        
        
    }
    

    
    func readReatimeLocation() {
        var data = readDataFromCSV(fileName: "realtimelocation", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        for (index, _)in csvRows.enumerated() {
    
            
            let point = Vehicles(time: (csvRows[index][0] ), vehicle: (csvRows[index][1] ), latitude: Double(csvRows[index][2]) ?? 0, Longitude: Double(csvRows[index][3]) ?? 0)
            VehicleOnRoad.append(point)
           
            if index == 10000 {
                break
            }
        }
        
        
    }
    //custom annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "car.png")
            annotationView.backgroundColor = UIColor.clear
            return annotationView
        }
    }
    
    
  
}
