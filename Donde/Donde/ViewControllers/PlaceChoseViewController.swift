//
//  PlaceChoseViewController.swift
//  Donde
//
//  Created by Jesus Garnica on 12/11/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit

class PlaceChoseViewController:  UIViewController {
    
    
    @IBAction func tryAgainPressed(_ sender: Any) {
         performSegueToReturnBack()
    }
    
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var imageToHold = UIImage.self
    var placeName = ""
    var markerChose = PlaceMarker?.self
    var address = ""
    var price = 0
    var aboutTextString = ""
    var rating = 0.0
     var ourPlacesArray = [PlaceMarker]()
    @IBOutlet weak var aboutText: UITextView!
    override func viewDidLoad()
    {
       super.viewDidLoad()
        let chosenNum = choseRandomPlace()
        //set our labels and images
        if(ourPlacesArray.count > 0){
            nameLabel.text = ourPlacesArray[chosenNum].place.name
            rating  = ourPlacesArray[chosenNum].place.rating ?? 0.0
            if ourPlacesArray[chosenNum].place.photo != nil{
                imagePlace.image = ourPlacesArray[chosenNum].place.photo
            }
            else
            {
                //DO NOT LOAD THE IMAGE. NO CRASHES ALLOWED
            }
            address = ourPlacesArray[chosenNum].place.address
            price = ourPlacesArray[chosenNum].place.price ?? 1
            let priceString = getPriceString()
            aboutTextString = "This place has a "+String(rating)+"! And its at "+address+". The cost is "+priceString+"."
            aboutText.text = aboutTextString
        }
        else{
            nameLabel.text = "Nothing decent is open!"
            aboutText.text = ""
        }
      
      
    }
    func getPriceString() -> String {
        if(price<=1){
            return "inexpensive"
        }
        else if (price==2){
            return "not bad but not cheap"
        }
        else if(price==3){
            return "pricey"
        }
        else{
            return "EXPENSIVE"
        }
    }
    //choose the place using chance
    func choseRandomPlace() -> Int {
        let length = ourPlacesArray.count - 1
        if(length<0){
            return -1
        }
        let randomNum = Int.random(in: 0 ..< length)
        return randomNum
    }
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    






}
