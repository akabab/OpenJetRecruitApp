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

    var sections = [String]()
    var items = [[Airport]]()

    var isSearching : Bool {
        return searchController.active && searchController.searchBar.text != ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        loadSampleAirports()
    }

    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.barTintColor = UIColor(red:0.58, green:0.74, blue:0.96, alpha:1.0)
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(red:0.58, green:0.74, blue:0.96, alpha:1.0).CGColor

        // ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active (when presenting alert for exemple) http://asciiwwdc.com/2014/sessions/228
        self.definesPresentationContext = true

        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchBar
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

    func createSections() {

        let tmp = airports.map { airport in
            return "\(airport["continent"]!) - \(airport["country"]!)"
        }

        // Distinct Values
        sections = Array(Set(tmp)).sort()

        items = [[Airport]](count: sections.count, repeatedValue: [])
        for airport in airports {
            let sectionIndex = sections.indexOf("\(airport["continent"]!) - \(airport["country"]!)")
            if let index = sectionIndex {
                items[index] += [airport]
            }
        }
    }

    // Searching
    func filterContentForSearchText(searchText: String) {
        filteredAirports = airports.filter { airport in
            let matchString = "\(airport["continent"]!) \(airport["country"]!) \(airport["city"]!) \(airport["name"]!) \(airport["iata"]!)".lowercaseString

            return matchString.containsString(searchText.lowercaseString)
        }

        tableView.reloadData()
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
        return isSearching ? 1 : sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredAirports.count : items[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching ? "\(filteredAirports.count) Result\(filteredAirports.count != 1 ? "s" : "")" : sections[section]
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red:0.58, green:0.74, blue:0.96, alpha:1.0)
        header.textLabel!.textColor = UIColor.whiteColor()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AirportTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AirportTableViewCell

        // Fetches the appropriate airport for the data source layout.
        let airport = isSearching ? filteredAirports[indexPath.row] : items[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = "\(airport["name"] ?? "") (\(airport["iata"] ?? ""))"
        cell.countryLabel.text = "\(airport["city"] ?? ""), \(airport["country"] ?? "")"
        
        return cell
    }
}
