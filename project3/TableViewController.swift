//
//  TableViewController.swift
//  project3
//
//  Created by Kruthika Holla on 11/9/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

protocol PassCityDelegate: class{
    var selectedCity: String? {get set}
    var passedModel: CitiesAfterSelectionModel? {get set}
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate{
    
    @IBOutlet weak var cityTableOutlet: UITableView!
    
    @IBOutlet weak var searchCity: UISearchBar!
    
    var model = WorldClockModel()
    var selectedCityForWorldClock: [String]?
    weak var delegate: PassCityDelegate?
    var searchResults = [String]() //holds the search results
    var searchActive: Bool = false
    var cityModel: CitiesAfterSelectionModel = CitiesAfterSelectionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTableOutlet.delegate = self
        
        cityTableOutlet.dataSource = self
        
        searchCity.delegate = self
        
        if (cityModel.cityLocationsArray.count == 0){
            model.getCityList()
            model.saveAddedCityData()
        }
        cityModel = CitiesAfterSelectionModel()
        cityModel.cityLocationsArray.sortInPlace()
    }
    
    

    //MARK: table view with cities
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (!searchActive && searchResults.count == 1){
            return 1
        }
        
        if(searchActive) {
            return searchResults.count
        }
        return cityModel.cityLocationsArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if(searchActive && searchResults.count > 0){
            cell.textLabel?.text = searchResults[indexPath.row]
        }
        if (!searchActive && searchResults.count == 1){
            cell.textLabel?.text = searchResults[indexPath.row]
        }
        if(!searchActive && searchResults.count == 0){
            cell.textLabel?.text = cityModel.cityLocationsArray[indexPath.row]
        }
        return cell
    }
    
    //On selection, remove the city from the cities array
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var city: String?
         if(searchActive && searchResults.count != 0) {
            city = searchResults[indexPath.row]
            let index = cityModel.cityLocationsArray.indexOf(city!)
            cityModel.cityLocationsArray.removeAtIndex(index!)
            
        }
        
        
        
         if ((!searchActive && searchResults.count != 1) || (searchActive && searchResults.count == 0)){
            city = cityModel.cityLocationsArray[indexPath.row]
            cityModel.cityLocationsArray.removeAtIndex(indexPath.row)
            
        }
        
        if (!searchActive && searchResults.count == 1){
             city = " "
        }
        //for data persistance
        model.deleteCityData()
        model.cityAfterAdd?.removeAll()
        model.saveAddedCityData()
        for city in cityModel.cityLocationsArray{
           model.cityAfterAdd?.append(AfterAddingCityData(cityArray: city))
        }
        model.saveAddedCityData()
        delegate?.passedModel = cityModel
        delegate?.selectedCity = city
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    //MARK: Searchbar
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        delegate?.selectedCity = " "
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchResults = cityModel.cityLocationsArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(searchResults.count == 0 && searchCity.text != ""){
            searchActive = false;
            searchResults.append("No Results")
        }
        else if(searchResults.count == 0 && searchCity.text == ""){
            searchActive = false;
        }
        else {
            searchActive = true;
        }
        self.cityTableOutlet.reloadData()
        
    }
    
}

























