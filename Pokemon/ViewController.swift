//
//  ViewController.swift
//  Pokemon
//
//  Created by Deborah Graham on 9/3/17.
//  Copyright © 2017 Deborah Graham. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            mapView.delegate = self
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player-1")
            
            var frame = annoView.frame
            frame.size.height = 25
            frame.size.width = 25
            
            annoView.frame = frame
            
            return annoView
        }
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annoView.image = UIImage(named: "mew")
        
        var frame = annoView.frame
        frame.size.height = 25
        frame.size.width = 25
        
        annoView.frame = frame
        
        return annoView
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if updateCount < 5 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 150, 150)
            
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }

    @IBAction func centerTapped(_ sender: Any) {
        if let cord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(cord, 150, 150)
            
            mapView.setRegion(region, animated: true)
        }
    }


    
}

