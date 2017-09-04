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
            setup()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //Spawns a Pokemon
            
            if let cord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno = PokeAnnotation(coord: cord, pokemon: pokemon)
                anno.coordinate = cord
                let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randomLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                anno.coordinate.latitude += randomLat
                anno.coordinate.longitude += randomLon
                self.mapView.addAnnotation(anno)
            }
        })
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
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)
        
        var frame = annoView.frame
        frame.size.height = 25
        frame.size.width = 25
        
        annoView.frame = frame
        
        return annoView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 150, 150)
        
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let cord = self.manager.location?.coordinate {
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(cord)) {
                    //Can catch the Pokemon
                    pokemon.caught = true
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congratulations!", message: "You caught \(pokemon.name!). You are a Pokemon master!", preferredStyle: .alert)
                    let pokedexaction = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                        self.performSegue(withIdentifier: "pokedexsegue", sender: nil)})
                    alertVC.addAction(pokedexaction)
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)

                } else {
                    //Too far away
                    let alertVC = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch \(pokemon.name!). Move closer to it.", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
        
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

