//
//  CountryModel.swift
//  CovidApp
//
//  Created by ic iMac on 16.06.20 : 25.
//  Copyright © 2020 interactive curiosity. All rights reserved.
//

import Foundation
import UIKit

class CountryModel {
    
    var countries: [Country] = []
    
    init() {
        //if let
        let url = URL(string: "https://api.covid19api.com/countries")!
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {
                print("Error on load data from \(url), \(error)")
                return
            }
            
            print(String(data: data, encoding: .utf8))
            do {
                let countryData = try Data(contentsOf: url)
                self.countries = try JSONDecoder().decode([Country].self, from: countryData)
                print("countries: \(self.countries)")
                print("countries count: \(self.countries.count)")
            } catch  {
                print(error)
            }
        }
        
        task.resume()
    }
    
}
