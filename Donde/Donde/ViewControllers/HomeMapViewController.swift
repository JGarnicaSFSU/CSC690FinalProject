//
//  HomeMapViewController.swift
//  Donde
//
//  Created by Jesus Garnica on 12/10/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//


/*
  This class is for managing the main view such as the map and buttons
 
 */
import UIKit
import GooglePlaces
import GoogleMaps
class HomeMapViewController: UIViewController {
    
    // Change how far we should search
    @IBAction func rangeButtonPressed(_ sender: Any) {
        if(searchRadius<1500){
            rangeButton.title = "Farther"
            searchRadius = 1500;
        }
        else{
            rangeButton.title = "Near"
            searchRadius = 500
            
        }
       
        fetchNearbyPlaces(coordinate: ourMapView.camera.target)

        
    }
    // We will attempt to pick a place
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
   
    private var searchRadius: Int = 500  //HOW BIG TO SEARCH
    
    @IBOutlet weak var ourMapView: GMSMapView!
    var foodTypes = ["bar","cafe","Food","restaurant"]
    
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
                    Only the finest places for our users.
                    ALSO THE PLACES MUST BE CHEAP!!!
                 
                */
               // place must be OPEN and have good ratings
                if let open = marker.place.open , open == true {
                    if let price = marker.place.price , price < 3{
                        if let rating = marker.place.rating , rating > 3.5 {
                            self.placesArray.append(marker)
                            marker.map = self.ourMapView
                        }
                    }else{
                        // It otherwise better be VERY VERY delicious 
                        if let rating = marker.place.rating , rating > 4.8 {
                            self.placesArray.append(marker)
                            marker.map = self.ourMapView
                        }
                    }
                   
                }

                

               
            }
        }
    }
    
   
}
/*
    This extension is for grabbing the user location and taking action when location
    changes
 */
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
