//
//  PlacePin.swift
//  Donde
//
//  Created by Jesus Garnica on 12/13/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    //
    let place: GooglePlace
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin") //Generic google Pin
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}

