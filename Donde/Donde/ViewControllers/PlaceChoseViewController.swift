//
//  PlaceChoseViewController.swift
//  Donde
//
//  Created by Jesus Garnica on 12/13/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit

class PlaceChoseViewController:  UIViewController {
    
    
    @IBAction func tryAgainPressed(_ sender: Any) {
         performSegueToReturnBack()
    }
    
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var placeChosen = GooglePlace.self
    @IBOutlet weak var aboutText: UITextView!
    override func viewDidLoad()
    {
       super.viewDidLoad()
        nameLabel.text = placeChosen.returnName(placeChosen)()
    }
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    






}
