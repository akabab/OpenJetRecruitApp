//
//  AirportTableViewController.swift
//  Pods
//
//  Created by Yoann Cribier on 15/12/15.
//
//

import UIKit
import Alamofire
import SwiftyJSON

extension AirportTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

typealias Airport = [String:String]

class AirportTableViewController: UITableViewController {

    let dataModel = AirportDataModel()
    let countryRef = CountryRef()
    var searchController: UISearchController!

    var airports = [Airport]()
    var filteredAirports = [Airport]()

    var isSearching : Bool {
        return searchController.active && searchController.searchBar.text != ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        loadSampleAirports()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()

        // ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active (when presenting alert for exemple) http://asciiwwdc.com/2014/sessions/228
        self.definesPresentationContext = true

        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }

    func alert(title: String, message: String, style: UIAlertControllerStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func loadSampleAirports() {
        if airports.isEmpty {
            dataModel.fetchAirports() { (error, result) in
                if error != nil {
                    print(error)
                    self.alert("Error", message: error!, style: UIAlertControllerStyle.Alert)
                } else if result != nil {
                    self.airports = result!

                    self.createSections()

                    // Reload Table View
                    self.tableView.reloadData()
                }
            }
        }
    }

    // Searching
    func filterContentForSearchText(searchText: String) {
        filteredAirports = airports.filter { airport in
            let name = airport["name"]!.lowercaseString
            let iata = airport["iata"]!.lowercaseString

            return name.containsString(searchText.lowercaseString) || iata.containsString(searchText.lowercaseString)
        }

        tableView.reloadData()
    }


            }

        }
    }

    // Handle selection
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let airport = isSearching ? filteredAirports[indexPath.row] : airports[indexPath.row]

        dataModel.selectAirport(airport) { error in
            if error != nil {
                print(error)
                self.alert("Error", message: error!, style: UIAlertControllerStyle.Alert)
            } else {
                self.alert("Mail sent", message: "\(airport["name"]!) Airport selected", style: UIAlertControllerStyle.Alert)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredAirports.count : airports.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AirportTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AirportTableViewCell
        
        // Fetches the appropriate airport for the data source layout.
        let airport = isSearching ? filteredAirports[indexPath.row] : airports[indexPath.row]
        
        cell.nameLabel.text = "\(airport["name"] ?? "") (\(airport["iata"] ?? ""))"
        cell.countryLabel.text = "\(airport["city"] ?? ""), \(airport["country"] ?? "")"
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
