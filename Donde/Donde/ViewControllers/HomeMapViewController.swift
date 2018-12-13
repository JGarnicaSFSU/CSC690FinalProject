//
//  HomeMapViewController.swift
//  Donde
//
//  Created by Jesus Garnica on 12/13/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
class HomeMapViewController: UIViewController {
   
    @IBAction func RefreshPressed(_ sender: Any) {
        fetchNearbyPlaces(coordinate: ourMapView.camera.target)

    }
    private let dataProvider = GoogleDataProvider()
    private let locationManager = CLLocationManager()
   
    private let searchRadius: Int = 750  //HOW BIG TO SEARCH
    
    @IBOutlet weak var ourMapView: GMSMapView!
    var foodTypes = ["bakery", "italian", "cafe", "coffee", "mexican","Food","restaurant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
    }
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        
        ourMapView.clear() //Clears pins
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:Double(searchRadius), types: foodTypes) { places in
            places.forEach {
                //add pin
                let marker = PlaceMarker(place: $0)
                marker.map = self.ourMapView
            }
        }
    }
    
   
}
extension HomeMapViewController: GMSMapViewDelegate{
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
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
