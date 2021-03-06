//
//  GoogleDataWrapper.swift
//  Donde
//
//  Created by Jesus Garnica on 12/11/18.
//  Copyright © 2018 Jesus Garnica. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

/*
    This class actually grabs and parses the data from the API
    using SwiftyJSON and Google's API
 */


typealias PlacesCompletion = ([GooglePlace]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
    private var photoCache: [String: UIImage] = [:]
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    
    
    // This grabs the nearby places using Google's API
    func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: @escaping PlacesCompletion) -> Void {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
        //Combine the types availible to search
        let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
        urlString += "&types=\(typesString)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        //This grabs photos  but in an Async way
        placesTask = session.dataTask(with: url) { data, response, error in
            var placesArray: [GooglePlace] = []
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(placesArray)
                }
            }
            guard let data = data,
                let json = try? JSON(data: data, options: .mutableContainers),
                let results = json["results"].arrayObject as? [[String: Any]] else {
                    return
            }
            results.forEach {
                let place = GooglePlace(dictionary: $0, acceptedTypes: types)
                placesArray.append(place)
                if let reference = place.photoReference {
                    self.fetchPhotoFromReference(reference) { image in
                        place.photo = image
                    }
                }
            }
        }
        placesTask?.resume()
    }
    
    
    func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) -> Void {
        if let photo = photoCache[reference] {
            completion(photo)
        } else {
            //typical string to get an image
            //Cannot let max width get too big or it costs too much to load
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=\(reference)&key=\(googleApiKey)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            //this gets an image for us
            session.downloadTask(with: url) { url, response, error in
                var downloadedPhoto: UIImage? = nil
                defer {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        completion(downloadedPhoto)
                    }
                }
                
                guard let url = url else {
                    return
                }
                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }
                //actually get photo
                downloadedPhoto = UIImage(data: imageData)
                self.photoCache[reference] = downloadedPhoto
                }
                //its an async task
                .resume()
        }
    }
}

