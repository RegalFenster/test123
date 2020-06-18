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
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var countryName: String!
    var slug:String!
    var countryDetails: [CountryDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryLabel.text = countryName
        loadData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func loadData() {
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
                        self.confirmedLabel.text = "Confirmed: \(self.countryDetails[self.countryDetails.count - 1].Confirmed)"
                        self.activeLabel.text = "Active: \(self.countryDetails[self.countryDetails.count - 1].Active)"
                        
                        let latDouble = (self.countryDetails[self.countryDetails.count - 1].Lat as NSString).doubleValue
                        let lonDoulbe = (self.countryDetails[self.countryDetails.count - 1].Lon as NSString).doubleValue
                        
                        let center = CLLocationCoordinate2D(latitude: latDouble, longitude: lonDoulbe)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 0.1))
                        self.mapView.setRegion(region, animated: true)
                        
                    } else {
                        self.confirmedLabel.text = "Confirmed: -"
                        self.activeLabel.text = "Active: -"
                    }
                    
                }
                
            } catch  {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
}
