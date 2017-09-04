//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by Deborah Graham on 9/4/17.
//  Copyright © 2017 Deborah Graham. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
    
}
