//
//  ViewController.swift
//  GPSLocation
//
//  Created by Justice Dreischor on 19/03/2020.
//  Copyright © 2020 Justice Dreischor. All rights reserved.
//

import UIKit
import MapKit
class CustomPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location1: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location1
    }
}
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Pin location
        let location = CLLocationCoordinate2DMake(51.4416, 5.4697)
        //Pin location and zoom level, the less span value the more zoom
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        //Set region to map
        self.mapView.setRegion(region, animated: true)
        
        //Create and set pin
        let pin = CustomPin(pinTitle: "Pin City of Eindhoven", pinSubTitle: "Eindhoven", location1: location)
        self.mapView.addAnnotation(pin)
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation){
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named: "pin")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("annotation title == \(String(describing: view.annotation?.title))")
    }
}


