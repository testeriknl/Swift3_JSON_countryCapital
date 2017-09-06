//
//  ViewController.swift
//  countryCapital
//
//  Created by Nietzsky on 01/09/2017.
//  Copyright © 2017 Testerik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var countryTableView: UITableView!
    
    var fetchedCountry = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTableView.dataSource = self
        
        parseData()
        searchBar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func searchBar()  {
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.scopeButtonTitles = ["Country", "Capital"]
        self.countryTableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            parseData()
        }
        else {
            if searchBar.selectedScopeButtonIndex == 0 {
                
                fetchedCountry = fetchedCountry.filter({ (country) -> Bool in
                    return country.country.lowercased().contains(searchText.lowercased() )
                })
            }
            else {
                
                fetchedCountry = fetchedCountry.filter({ (country) -> Bool in
                    return country.capital.lowercased().contains(searchText.lowercased() )
                })
            }
        }
        self.countryTableView.reloadData()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedCountry.count
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = fetchedCountry[indexPath.row].country
        cell?.detailTextLabel?.text = fetchedCountry[indexPath.row].capital
        
        return cell!
        
    }
    
    func parseData() {
        
        fetchedCountry = []
        
        let url = "https://restcountries.eu/rest/v1/all"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print("Error")
            }
            else {
                
                do {
                    //get data
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    print(fetchedData)
                    
                    for eachFetchedCountry in fetchedData {
                        
                        let eachCountry = eachFetchedCountry as! [String : Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                    }
                    //print(self.fetchedCountry)
                    
                    self.countryTableView.reloadData()
                    
                }
                catch {
                     print("Error 2")
                }
                
            }
        }
        task.resume()
    }

    
    
    
    

}

class Country {
    
    
    var country : String
    var capital : String
    //var currency : String
    //initializer
    init(country : String , capital : String) {
        self.country = country
        self.capital = capital
    }
    
}
