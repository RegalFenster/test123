//
//  DetailViewController.swift
//  CovidApp
//
//  Created by ic iMac on 16.06.20 : 25.
//  Copyright © 2020 interactive curiosity. All rights reserved.
//
import CoreLocation
import UIKit
import MapKit


class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    
    @IBOutlet weak var mapKitViewOutlet: MKMapView!
    
     let locationManager = CLLocationManager()
    
    
    var countryName: String!
    var slug:String!
    var countryDetails: [CountryDetail] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryLabel.text = countryName
        loadData()
        
    }
    
    
    func loadData() {
        
        locationManager.delegate = self
                                     locationManager.requestWhenInUseAuthorization()
                                     locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                                     locationManager.stopUpdatingLocation()
                                     mapKitViewOutlet.showsUserLocation = true
                              
        
        let url = URL(string: "https://api.covid19api.com/live/country/" + slug)!
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {
                print("Error on load data from \(url), \(error)")
                return
            }
            
            do {
                let countryData = try Data(contentsOf: url)
                self.countryDetails = try JSONDecoder().decode([CountryDetail].self, from: countryData)
                print(self.countryDetails.count)
                OperationQueue.main.addOperation {
                    if self.countryDetails.count > 0 {
                        
                        // Update UI 
                        self.confirmedLabel.text = "Confirmed: \(self.countryDetails[self.countryDetails.count - 1].Confirmed)"
                        self.activeLabel.text = "Active: \(self.countryDetails[self.countryDetails.count - 1].Active)"
                        
                        
                    } else {
                        self.confirmedLabel.text = "Confirmed: -"
                        self.activeLabel.text = "Active: -"
                    }
                    

                      
                    let lat = (Double(self.countryDetails[self.countryDetails.count - 1].Lat))!
                    let long = (Double(self.countryDetails[self.countryDetails.count - 1].Lon))!
                            
                            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                    self.mapKitViewOutlet.setRegion(region, animated: true)
                            
                    
                    
                }
                
            } catch  {
                print(error)
            }
            
        }
        
        
        task.resume()
    }
    
    
}
