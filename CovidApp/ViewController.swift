//
//  ViewController.swift
//  CovidApp
//
//  Created by ic iMac on 16.06.20 : 25.
//  Copyright © 2020 interactive curiosity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableView.dataSource = self
        countryTableView.delegate = self
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCell = sender as! UITableViewCell
        let selectedIndexPath = countryTableView.indexPath(for: selectedCell)!
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.countryName = countries [selectedIndexPath.row].Country
        detailViewController.slug = countries [selectedIndexPath.row].Slug
    }
    
    func loadData() {
        let url = URL(string: "https://api.covid19api.com/countries")!
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {
                print("Error on load data from \(url), \(error)")
                return
            }
            
            do {
                let countryData = try Data(contentsOf: url)
                self.countries = try JSONDecoder().decode([Country].self, from: countryData)
                OperationQueue.main.addOperation {
                    self.countryTableView.reloadData()
                }
                
            } catch  {
                print(error)
            }
        }
        
        task.resume()
    }
    
    
}


extension ViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countries [indexPath.row]
        
        cell.textLabel?.text = country.Country
        
        return cell
    }
    
    
}

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select: \(indexPath.row)")
    }
}

