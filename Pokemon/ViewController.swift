//
//  ViewController.swift
//  Pokemon
//
//  Created by Deborah Graham on 9/3/17.
//  Copyright © 2017 Deborah Graham. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Ready to go!")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //Spaws a Pokemon
                
                if let cord = self.manager.location?.coordinate {
                    let anno = MKPointAnnotation()
                    anno.coordinate = cord
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    let randomLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    anno.coordinate.latitude += randomLat
                    anno.coordinate.longitude += randomLon
                    self.mapView.addAnnotation(anno)
                }
            })
            
        } else {
            manager.requestWhenInUseAuthorization()

        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if updateCount < 5 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }

    @IBAction func centerTapped(_ sender: Any) {
        if let cord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(cord, 200, 200)
            
            mapView.setRegion(region, animated: true)
        }
    }

}

