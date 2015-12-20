//
//  AirportDataModel.swift
//  OpenJetRecruitApp
//
//  Created by Yoann Cribier on 16/12/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AirportDataModel {

    let countryRef = CountryRef()

    func fetchAirports(callback: (error: String?, result: [Airport]?) -> Void) {
        var airports = [Airport]()

        func assertDataKeys (keys: [String]) -> Bool {
            let matchKeys = ["city", "countryCode", "faaCode", "iata", "icao", "latitudeDecimal", "lfi", "longitudeDecimal", "name", "utcStdConversion"]

            return keys == matchKeys
        }

        let continentsRef = [
            "AF": ["Afrique", "Africa"],
            "AN": ["Antarctique", "Antarctica"],
            "AS": ["Asie", "Asia"],
            "EU": ["Europe", "Europe"],
            "NA": ["Amérique du Nord", "North America"],
            "OC": ["Océanie", "Oceania"],
            "SA": ["Amérique du Sud", "South America"]
        ]

        Alamofire.request(.GET, "http://middle.openjetlab.fr/api/rests/airport/list").validate().responseJSON() {
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)

                    if let jsonArray = json.array {
                        for item in jsonArray {
                            if let itemDictionary = item.dictionary {
                                if (assertDataKeys(itemDictionary.keys.sort()) == false) {
                                    print("assert keys failed")
                                    continue
                                }

                                var newAirport = Airport()
                                for (key, value) in itemDictionary {
                                    newAirport[key] = value.string
                                }

                                // match country
                                if let countryCode = newAirport["countryCode"] {
                                    if let ref = self.countryRef.table[countryCode] {
                                        newAirport["country"] = ref[4]
                                        newAirport["continentCode"] = ref[3]
                                    } else {
                                        print(countryCode)
                                    }

                                    if let continent = continentsRef[newAirport["continentCode"]!] {
                                        newAirport["continent"] = continent[0]
                                    } else {
                                        print(newAirport["continentCode"])
                                    }
                                }
                                
                                // Add airport
                                airports += [newAirport]
                            }
                        }
                    }

                    return callback(error: nil, result: airports)
                }

            case .Failure(let error):
                return callback(error: error.localizedDescription, result: nil)
            }
        }
    }

    func selectAirport(airport: Airport, callback: (error: String?) -> Void) {
        let params : [String: AnyObject] = [
            "city": airport["city"]!,
            "airport": airport["name"]!,
            "timezone": airport["utcStdConversion"]!
        ]

        Alamofire.request(.POST, "http://candidat.openjetlab.fr/", parameters: params).response() {
            (request, response, data, error) in

            if error != nil || response == nil || response!.statusCode != 200 {
                print(error)
                return callback(error: error?.localizedDescription)
            }

            return callback(error: nil)
        }
    }
}
