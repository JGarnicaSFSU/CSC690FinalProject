//
//  HomeMapViewController.swift
//  Donde
//
//  Created by Jesus Garnica on 12/10/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
class HomeMapViewController: UIViewController {
    @IBAction func rangeButtonPressed(_ sender: Any) {
        if(searchRadius<1500){
            rangeButton.title = "Farther"
            searchRadius = 1500;
        }
        else{
            rangeButton.title = "Near"
            searchRadius = 750
            
        }
       
        fetchNearbyPlaces(coordinate: ourMapView.camera.target)

        
    }
    @IBAction func pickPressed(_ sender: Any) {
         performSegue(withIdentifier: "placeChosenSegue", sender: self)
    }
    var placesArray = [PlaceMarker]()
    
    @IBOutlet weak var rangeButton: UIBarButtonItem!
    @IBAction func RefreshPressed(_ sender: Any) {
        fetchNearbyPlaces(coordinate: ourMapView.camera.target)

    }
    //getting ready to display place
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeChosenSegue"{
            let vc = segue.destination as? PlaceChoseViewController
            vc?.ourPlacesArray = placesArray
           
        }
    }
    
    private let dataProvider = GoogleDataProvider()
    private let locationManager = CLLocationManager()
   
    private var searchRadius: Int = 750  //HOW BIG TO SEARCH
    
    @IBOutlet weak var ourMapView: GMSMapView!
    var foodTypes = ["bakery", "italian", "cafe", "coffee", "mexican","Food","restaurant","tacos","burritos","falafel","bar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
    }
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
         self.placesArray.removeAll()
        ourMapView.clear() //Clears pins
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:Double(searchRadius), types: foodTypes) { places in
            places.forEach {
                //add pin
                
                let marker = PlaceMarker(place: $0)
                /*
                    Only the finest places for our users
                */
               
                if let open = marker.place.open , open == true {
                    if let rating = marker.place.rating , rating > 3.75 {
                        self.placesArray.append(marker)
                         marker.map = self.ourMapView
                    }
                }

                

               
            }
        }
    }
    
   
}

extension HomeMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
       
        locationManager.startUpdatingLocation()
        
        
        ourMapView.isMyLocationEnabled = true
        ourMapView.settings.myLocationButton = true
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
       
        ourMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        fetchNearbyPlaces(coordinate: location.coordinate)

        locationManager.stopUpdatingLocation()
    }
}
