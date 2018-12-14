//
//  GooglePlace.swift
//  Donde
//
//  Created by Jesus Garnica
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//


import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    let rating: Double?
    let open: Bool?
    let price:Int?
    var photoReference: String?
    var photo: UIImage?
    
    init(dictionary: [String: Any], acceptedTypes: [String])
    {
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        
            rating = json["rating"].doubleValue
        open = json["opening_hours"]["open_now"].boolValue
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        print(json)
        photoReference = json["photos"][0]["photo_reference"].string
        
        price = json["price_level"].intValue
        placeType = ""
    }
    
    func returnName() -> String {
        return name
    }
    

}

