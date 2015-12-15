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

class AirportTableViewController: UITableViewController {
    
    var airports = [Dictionary<String, String?>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleAirports()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    func loadSampleAirports () {
        if airports.isEmpty {
            fetchAirports()
        }
    }
    
    func fetchAirports() {
        Alamofire.request(.GET, "http://middle.openjetlab.fr/api/rests/airport/list").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if let jsonArray = json.array {
                        for item in jsonArray {
                            if let itemDictionary = item.dictionary {
                                var newAirport = [String:String?]()
                                for (key, value) in itemDictionary {
                                    newAirport[key] = value.string
                                }
                                
                                // match country
                                let countryCode = newAirport["countryCode"] ?? ""
                                newAirport["country"] = self.airportCountriesRef[countryCode!]![4]
                                newAirport["continentCode"] = self.airportCountriesRef[countryCode!]![0]
                                
                                // Add airport
                                self.airports += [newAirport]
                            }
                        }
                    }
                    
                    // Reload Table View
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            case .Failure(let error):
                print("Err: ", error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(airports.count)
        return airports.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AirportTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AirportTableViewCell
        
        // Fetches the appropriate airport for the data source layout.
        let airport = airports[indexPath.row]
        
        cell.nameLabel.text = airport["name"] ?? ""
        cell.countryLabel.text = airport["country"] ?? ""
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let airportCountriesRef : [String: [String]] = [
        "AD": [ "EU" , "AD" , "AND" , "20"  , "Andorra, Principality of"                            ],
        "AE": [ "AS" , "AE" , "ARE" , "784" , "United Arab Emirates"                                ],
        "AF": [ "AS" , "AF" , "AFG" , "4"   , "Afghanistan, Islamic Republic of"                    ],
        "AG": [ "NA" , "AG" , "ATG" , "28"  , "Antigua and Barbuda"                                 ],
        "AI": [ "NA" , "AI" , "AIA" , "660" , "Anguilla"                                            ],
        "AL": [ "EU" , "AL" , "ALB" , "8"   , "Albania, Republic of"                                ],
        "AM": [ "AS" , "AM" , "ARM" , "51"  , "Armenia, Republic of"                                ],
//        "AM": [ "EU" , "AM" , "ARM" , "51"  , "Armenia, Republic of"                                ],
        "AN": [ "NA" , "AN" , "ANT" , "530" , "Netherlands Antilles"                                ],
        "AO": [ "AF" , "AO" , "AGO" , "24"  , "Angola, Republic of"                                 ],
        "AQ": [ "AN" , "AQ" , "ATA" , "10"  , "Antarctica (the territory South of 60 deg S)"        ],
        "AR": [ "SA" , "AR" , "ARG" , "32"  , "Argentina, Argentine Republic"                       ],
        "AS": [ "OC" , "AS" , "ASM" , "16"  , "American Samoa"                                      ],
        "AT": [ "EU" , "AT" , "AUT" , "40"  , "Austria, Republic of"                                ],
        "AU": [ "OC" , "AU" , "AUS" , "36"  , "Australia, Commonwealth of"                          ],
        "AW": [ "NA" , "AW" , "ABW" , "533" , "Aruba"                                               ],
        "AX": [ "EU" , "AX" , "ALA" , "248" , "Ã…land Islands"                                      ],
        "AZ": [ "AS" , "AZ" , "AZE" , "31"  , "Azerbaijan, Republic of"                             ],
//        "AZ": [ "EU" , "AZ" , "AZE" , "31"  , "Azerbaijan, Republic of"                             ],
        "BA": [ "EU" , "BA" , "BIH" , "70"  , "Bosnia and Herzegovina"                              ],
        "BB": [ "NA" , "BB" , "BRB" , "52"  , "Barbados"                                            ],
        "BD": [ "AS" , "BD" , "BGD" , "50"  , "Bangladesh, People's Republic of"                    ],
        "BE": [ "EU" , "BE" , "BEL" , "56"  , "Belgium, Kingdom of"                                 ],
        "BF": [ "AF" , "BF" , "BFA" , "854" , "Burkina Faso"                                        ],
        "BG": [ "EU" , "BG" , "BGR" , "100" , "Bulgaria, Republic of"                               ],
        "BH": [ "AS" , "BH" , "BHR" , "48"  , "Bahrain, Kingdom of"                                 ],
        "BI": [ "AF" , "BI" , "BDI" , "108" , "Burundi, Republic of"                                ],
        "BJ": [ "AF" , "BJ" , "BEN" , "204" , "Benin, Republic of"                                  ],
        "BL": [ "NA" , "BL" , "BLM" , "652" , "Saint Barthelemy"                                    ],
        "BM": [ "NA" , "BM" , "BMU" , "60"  , "Bermuda"                                             ],
        "BN": [ "AS" , "BN" , "BRN" , "96"  , "Brunei Darussalam"                                   ],
        "BO": [ "SA" , "BO" , "BOL" , "68"  , "Bolivia, Republic of"                                ],
        "BQ": [ "NA" , "BQ" , "BES" , "535" , "Bonaire, Sint Eustatius and Saba"                    ],
        "BR": [ "SA" , "BR" , "BRA" , "76"  , "Brazil, Federative Republic of"                      ],
        "BS": [ "NA" , "BS" , "BHS" , "44"  , "Bahamas, Commonwealth of the"                        ],
        "BT": [ "AS" , "BT" , "BTN" , "64"  , "Bhutan, Kingdom of"                                  ],
        "BV": [ "AN" , "BV" , "BVT" , "74"  , "Bouvet Island (Bouvetoya)"                           ],
        "BW": [ "AF" , "BW" , "BWA" , "72"  , "Botswana, Republic of"                               ],
        "BY": [ "EU" , "BY" , "BLR" , "112" , "Belarus, Republic of"                                ],
        "BZ": [ "NA" , "BZ" , "BLZ" , "84"  , "Belize"                                              ],
        "CA": [ "NA" , "CA" , "CAN" , "124" , "Canada"                                              ],
        "CC": [ "AS" , "CC" , "CCK" , "166" , "Cocos (Keeling) Islands"                             ],
        "CD": [ "AF" , "CD" , "COD" , "180" , "Congo, Democratic Republic of the"                   ],
        "CF": [ "AF" , "CF" , "CAF" , "140" , "Central African Republic"                            ],
        "CG": [ "AF" , "CG" , "COG" , "178" , "Congo, Republic of the"                              ],
        "CH": [ "EU" , "CH" , "CHE" , "756" , "Switzerland, Swiss Confederation"                    ],
        "CI": [ "AF" , "CI" , "CIV" , "384" , "Cote d'Ivoire, Republic of"                          ],
        "CK": [ "OC" , "CK" , "COK" , "184" , "Cook Islands"                                        ],
        "CL": [ "SA" , "CL" , "CHL" , "152" , "Chile, Republic of"                                  ],
        "CM": [ "AF" , "CM" , "CMR" , "120" , "Cameroon, Republic of"                               ],
        "CN": [ "AS" , "CN" , "CHN" , "156" , "China, People's Republic of"                         ],
        "CO": [ "SA" , "CO" , "COL" , "170" , "Colombia, Republic of"                               ],
        "CR": [ "NA" , "CR" , "CRI" , "188" , "Costa Rica, Republic of"                             ],
        "CU": [ "NA" , "CU" , "CUB" , "192" , "Cuba, Republic of"                                   ],
        "CV": [ "AF" , "CV" , "CPV" , "132" , "Cape Verde, Republic of"                             ],
        "CW": [ "NA" , "CW" , "CUW" , "531" , "CuraÃ§ao"                                            ],
        "CX": [ "AS" , "CX" , "CXR" , "162" , "Christmas Island"                                    ],
//        "CY": [ "AS" , "CY" , "CYP" , "196" , "Cyprus, Republic of"                                 ],
        "CY": [ "EU" , "CY" , "CYP" , "196" , "Cyprus, Republic of"                                 ],
        "CZ": [ "EU" , "CZ" , "CZE" , "203" , "Czech Republic"                                      ],
        "DE": [ "EU" , "DE" , "DEU" , "276" , "Germany, Federal Republic of"                        ],
        "DJ": [ "AF" , "DJ" , "DJI" , "262" , "Djibouti, Republic of"                               ],
        "DK": [ "EU" , "DK" , "DNK" , "208" , "Denmark, Kingdom of"                                 ],
        "DM": [ "NA" , "DM" , "DMA" , "212" , "Dominica, Commonwealth of"                           ],
        "DO": [ "NA" , "DO" , "DOM" , "214" , "Dominican Republic"                                  ],
        "DZ": [ "AF" , "DZ" , "DZA" , "12"  , "Algeria, People's Democratic Republic of"            ],
        "EC": [ "SA" , "EC" , "ECU" , "218" , "Ecuador, Republic of"                                ],
        "EE": [ "EU" , "EE" , "EST" , "233" , "Estonia, Republic of"                                ],
        "EG": [ "AF" , "EG" , "EGY" , "818" , "Egypt, Arab Republic of"                             ],
        "EH": [ "AF" , "EH" , "ESH" , "732" , "Western Sahara"                                      ],
        "ER": [ "AF" , "ER" , "ERI" , "232" , "Eritrea, State of"                                   ],
        "ES": [ "EU" , "ES" , "ESP" , "724" , "Spain, Kingdom of"                                   ],
        "ET": [ "AF" , "ET" , "ETH" , "231" , "Ethiopia, Federal Democratic Republic of"            ],
        "FI": [ "EU" , "FI" , "FIN" , "246" , "Finland, Republic of"                                ],
        "FJ": [ "OC" , "FJ" , "FJI" , "242" , "Fiji, Republic of the Fiji Islands"                  ],
        "FK": [ "SA" , "FK" , "FLK" , "238" , "Falkland Islands (Malvinas)"                         ],
        "FM": [ "OC" , "FM" , "FSM" , "583" , "Micronesia, Federated States of"                     ],
        "FO": [ "EU" , "FO" , "FRO" , "234" , "Faroe Islands"                                       ],
        "FR": [ "EU" , "FR" , "FRA" , "250" , "France, French Republic"                             ],
        "GA": [ "AF" , "GA" , "GAB" , "266" , "Gabon, Gabonese Republic"                            ],
        "GB": [ "EU" , "GB" , "GBR" , "826" , "United Kingdom of Great Britain & Northern Ireland"  ],
        "GD": [ "NA" , "GD" , "GRD" , "308" , "Grenada"                                             ],
        "GE": [ "AS" , "GE" , "GEO" , "268" , "Georgia"                                             ],
//        "GE": [ "EU" , "GE" , "GEO" , "268" , "Georgia"                                             ],
        "GF": [ "SA" , "GF" , "GUF" , "254" , "French Guiana"                                       ],
        "GG": [ "EU" , "GG" , "GGY" , "831" , "Guernsey, Bailiwick of"                              ],
        "GH": [ "AF" , "GH" , "GHA" , "288" , "Ghana, Republic of"                                  ],
        "GI": [ "EU" , "GI" , "GIB" , "292" , "Gibraltar"                                           ],
        "GL": [ "NA" , "GL" , "GRL" , "304" , "Greenland"                                           ],
        "GM": [ "AF" , "GM" , "GMB" , "270" , "Gambia, Republic of the"                             ],
        "GN": [ "AF" , "GN" , "GIN" , "324" , "Guinea, Republic of"                                 ],
        "GP": [ "NA" , "GP" , "GLP" , "312" , "Guadeloupe"                                          ],
        "GQ": [ "AF" , "GQ" , "GNQ" , "226" , "Equatorial Guinea, Republic of"                      ],
        "GR": [ "EU" , "GR" , "GRC" , "300" , "Greece, Hellenic Republic"                           ],
        "GS": [ "AN" , "GS" , "SGS" , "239" , "South Georgia and the South Sandwich Islands"        ],
        "GT": [ "NA" , "GT" , "GTM" , "320" , "Guatemala, Republic of"                              ],
        "GU": [ "OC" , "GU" , "GUM" , "316" , "Guam"                                                ],
        "GW": [ "AF" , "GW" , "GNB" , "624" , "Guinea-Bissau, Republic of"                          ],
        "GY": [ "SA" , "GY" , "GUY" , "328" , "Guyana, Co-operative Republic of"                    ],
        "HK": [ "AS" , "HK" , "HKG" , "344" , "Hong Kong, Special Administrative Region of China"   ],
        "HM": [ "AN" , "HM" , "HMD" , "334" , "Heard Island and McDonald Islands"                   ],
        "HN": [ "NA" , "HN" , "HND" , "340" , "Honduras, Republic of"                               ],
        "HR": [ "EU" , "HR" , "HRV" , "191" , "Croatia, Republic of"                                ],
        "HT": [ "NA" , "HT" , "HTI" , "332" , "Haiti, Republic of"                                  ],
        "HU": [ "EU" , "HU" , "HUN" , "348" , "Hungary, Republic of"                                ],
        "ID": [ "AS" , "ID" , "IDN" , "360" , "Indonesia, Republic of"                              ],
        "IE": [ "EU" , "IE" , "IRL" , "372" , "Ireland"                                             ],
        "IL": [ "AS" , "IL" , "ISR" , "376" , "Israel, State of"                                    ],
        "IM": [ "EU" , "IM" , "IMN" , "833" , "Isle of Man"                                         ],
        "IN": [ "AS" , "IN" , "IND" , "356" , "India, Republic of"                                  ],
        "IO": [ "AS" , "IO" , "IOT" , "86"  , "British Indian Ocean Territory (Chagos Archipelago)" ],
        "IQ": [ "AS" , "IQ" , "IRQ" , "368" , "Iraq, Republic of"                                   ],
        "IR": [ "AS" , "IR" , "IRN" , "364" , "Iran, Islamic Republic of"                           ],
        "IS": [ "EU" , "IS" , "ISL" , "352" , "Iceland, Republic of"                                ],
        "IT": [ "EU" , "IT" , "ITA" , "380" , "Italy, Italian Republic"                             ],
        "JE": [ "EU" , "JE" , "JEY" , "832" , "Jersey, Bailiwick of"                                ],
        "JM": [ "NA" , "JM" , "JAM" , "388" , "Jamaica"                                             ],
        "JO": [ "AS" , "JO" , "JOR" , "400" , "Jordan, Hashemite Kingdom of"                        ],
        "JP": [ "AS" , "JP" , "JPN" , "392" , "Japan"                                               ],
        "KE": [ "AF" , "KE" , "KEN" , "404" , "Kenya, Republic of"                                  ],
        "KG": [ "AS" , "KG" , "KGZ" , "417" , "Kyrgyz Republic"                                     ],
        "KH": [ "AS" , "KH" , "KHM" , "116" , "Cambodia, Kingdom of"                                ],
        "KI": [ "OC" , "KI" , "KIR" , "296" , "Kiribati, Republic of"                               ],
        "KM": [ "AF" , "KM" , "COM" , "174" , "Comoros, Union of the"                               ],
        "KN": [ "NA" , "KN" , "KNA" , "659" , "Saint Kitts and Nevis, Federation of"                ],
        "KP": [ "AS" , "KP" , "PRK" , "408" , "Korea, Democratic People's Republic of"              ],
        "KR": [ "AS" , "KR" , "KOR" , "410" , "Korea, Republic of"                                  ],
        "KW": [ "AS" , "KW" , "KWT" , "414" , "Kuwait, State of"                                    ],
        "KY": [ "NA" , "KY" , "CYM" , "136" , "Cayman Islands"                                      ],
        "KZ": [ "AS" , "KZ" , "KAZ" , "398" , "Kazakhstan, Republic of"                             ],
//        "KZ": [ "EU" , "KZ" , "KAZ" , "398" , "Kazakhstan, Republic of"                             ],
        "LA": [ "AS" , "LA" , "LAO" , "418" , "Lao People's Democratic Republic"                    ],
        "LB": [ "AS" , "LB" , "LBN" , "422" , "Lebanon, Lebanese Republic"                          ],
        "LC": [ "NA" , "LC" , "LCA" , "662" , "Saint Lucia"                                         ],
        "LI": [ "EU" , "LI" , "LIE" , "438" , "Liechtenstein, Principality of"                      ],
        "LK": [ "AS" , "LK" , "LKA" , "144" , "Sri Lanka, Democratic Socialist Republic of"         ],
        "LR": [ "AF" , "LR" , "LBR" , "430" , "Liberia, Republic of"                                ],
        "LS": [ "AF" , "LS" , "LSO" , "426" , "Lesotho, Kingdom of"                                 ],
        "LT": [ "EU" , "LT" , "LTU" , "440" , "Lithuania, Republic of"                              ],
        "LU": [ "EU" , "LU" , "LUX" , "442" , "Luxembourg, Grand Duchy of"                          ],
        "LV": [ "EU" , "LV" , "LVA" , "428" , "Latvia, Republic of"                                 ],
        "LY": [ "AF" , "LY" , "LBY" , "434" , "Libyan Arab Jamahiriya"                              ],
        "MA": [ "AF" , "MA" , "MAR" , "504" , "Morocco, Kingdom of"                                 ],
        "MC": [ "EU" , "MC" , "MCO" , "492" , "Monaco, Principality of"                             ],
        "MD": [ "EU" , "MD" , "MDA" , "498" , "Moldova, Republic of"                                ],
        "ME": [ "EU" , "ME" , "MNE" , "499" , "Montenegro, Republic of"                             ],
        "MF": [ "NA" , "MF" , "MAF" , "663" , "Saint Martin"                                        ],
        "MG": [ "AF" , "MG" , "MDG" , "450" , "Madagascar, Republic of"                             ],
        "MH": [ "OC" , "MH" , "MHL" , "584" , "Marshall Islands, Republic of the"                   ],
        "MK": [ "EU" , "MK" , "MKD" , "807" , "Macedonia, Republic of"                              ],
        "ML": [ "AF" , "ML" , "MLI" , "466" , "Mali, Republic of"                                   ],
        "MM": [ "AS" , "MM" , "MMR" , "104" , "Myanmar, Union of"                                   ],
        "MN": [ "AS" , "MN" , "MNG" , "496" , "Mongolia"                                            ],
        "MO": [ "AS" , "MO" , "MAC" , "446" , "Macao, Special Administrative Region of China"       ],
        "MP": [ "OC" , "MP" , "MNP" , "580" , "Northern Mariana Islands, Commonwealth of the"       ],
        "MQ": [ "NA" , "MQ" , "MTQ" , "474" , "Martinique"                                          ],
        "MR": [ "AF" , "MR" , "MRT" , "478" , "Mauritania, Islamic Republic of"                     ],
        "MS": [ "NA" , "MS" , "MSR" , "500" , "Montserrat"                                          ],
        "MT": [ "EU" , "MT" , "MLT" , "470" , "Malta, Republic of"                                  ],
        "MU": [ "AF" , "MU" , "MUS" , "480" , "Mauritius, Republic of"                              ],
        "MV": [ "AS" , "MV" , "MDV" , "462" , "Maldives, Republic of"                               ],
        "MW": [ "AF" , "MW" , "MWI" , "454" , "Malawi, Republic of"                                 ],
        "MX": [ "NA" , "MX" , "MEX" , "484" , "Mexico, United Mexican States"                       ],
        "MY": [ "AS" , "MY" , "MYS" , "458" , "Malaysia"                                            ],
        "MZ": [ "AF" , "MZ" , "MOZ" , "508" , "Mozambique, Republic of"                             ],
        "NA": [ "AF" , "NA" , "NAM" , "516" , "Namibia, Republic of"                                ],
        "NC": [ "OC" , "NC" , "NCL" , "540" , "New Caledonia"                                       ],
        "NE": [ "AF" , "NE" , "NER" , "562" , "Niger, Republic of"                                  ],
        "NF": [ "OC" , "NF" , "NFK" , "574" , "Norfolk Island"                                      ],
        "NG": [ "AF" , "NG" , "NGA" , "566" , "Nigeria, Federal Republic of"                        ],
        "NI": [ "NA" , "NI" , "NIC" , "558" , "Nicaragua, Republic of"                              ],
        "NL": [ "EU" , "NL" , "NLD" , "528" , "Netherlands, Kingdom of the"                         ],
        "NO": [ "EU" , "NO" , "NOR" , "578" , "Norway, Kingdom of"                                  ],
        "NP": [ "AS" , "NP" , "NPL" , "524" , "Nepal, State of"                                     ],
        "NR": [ "OC" , "NR" , "NRU" , "520" , "Nauru, Republic of"                                  ],
        "NU": [ "OC" , "NU" , "NIU" , "570" , "Niue"                                                ],
        "NZ": [ "OC" , "NZ" , "NZL" , "554" , "New Zealand"                                         ],
        "OM": [ "AS" , "OM" , "OMN" , "512" , "Oman, Sultanate of"                                  ],
        "PA": [ "NA" , "PA" , "PAN" , "591" , "Panama, Republic of"                                 ],
        "PE": [ "SA" , "PE" , "PER" , "604" , "Peru, Republic of"                                   ],
        "PF": [ "OC" , "PF" , "PYF" , "258" , "French Polynesia"                                    ],
        "PG": [ "OC" , "PG" , "PNG" , "598" , "Papua New Guinea, Independent State of"              ],
        "PH": [ "AS" , "PH" , "PHL" , "608" , "Philippines, Republic of the"                        ],
        "PK": [ "AS" , "PK" , "PAK" , "586" , "Pakistan, Islamic Republic of"                       ],
        "PL": [ "EU" , "PL" , "POL" , "616" , "Poland, Republic of"                                 ],
        "PM": [ "NA" , "PM" , "SPM" , "666" , "Saint Pierre and Miquelon"                           ],
        "PN": [ "OC" , "PN" , "PCN" , "612" , "Pitcairn Islands"                                    ],
        "PR": [ "NA" , "PR" , "PRI" , "630" , "Puerto Rico, Commonwealth of"                        ],
        "PS": [ "AS" , "PS" , "PSE" , "275" , "Palestinian Territory, Occupied"                     ],
        "PT": [ "EU" , "PT" , "PRT" , "620" , "Portugal, Portuguese Republic"                       ],
        "PW": [ "OC" , "PW" , "PLW" , "585" , "Palau, Republic of"                                  ],
        "PY": [ "SA" , "PY" , "PRY" , "600" , "Paraguay, Republic of"                               ],
        "QA": [ "AS" , "QA" , "QAT" , "634" , "Qatar, State of"                                     ],
        "RE": [ "AF" , "RE" , "REU" , "638" , "Reunion"                                             ],
        "RO": [ "EU" , "RO" , "ROU" , "642" , "Romania"                                             ],
        "RS": [ "EU" , "RS" , "SRB" , "688" , "Serbia, Republic of"                                 ],
//        "RU": [ "AS" , "RU" , "RUS" , "643" , "Russian Federation"                                  ],
        "RU": [ "EU" , "RU" , "RUS" , "643" , "Russian Federation"                                  ],
        "RW": [ "AF" , "RW" , "RWA" , "646" , "Rwanda, Republic of"                                 ],
        "SA": [ "AS" , "SA" , "SAU" , "682" , "Saudi Arabia, Kingdom of"                            ],
        "SB": [ "OC" , "SB" , "SLB" , "90"  , "Solomon Islands"                                     ],
        "SC": [ "AF" , "SC" , "SYC" , "690" , "Seychelles, Republic of"                             ],
        "SD": [ "AF" , "SD" , "SDN" , "736" , "Sudan, Republic of"                                  ],
        "SE": [ "EU" , "SE" , "SWE" , "752" , "Sweden, Kingdom of"                                  ],
        "SG": [ "AS" , "SG" , "SGP" , "702" , "Singapore, Republic of"                              ],
        "SH": [ "AF" , "SH" , "SHN" , "654" , "Saint Helena"                                        ],
        "SI": [ "EU" , "SI" , "SVN" , "705" , "Slovenia, Republic of"                               ],
        "SJ": [ "EU" , "SJ" , "SJM" , "744" , "Svalbard & Jan Mayen Islands"                        ],
        "SK": [ "EU" , "SK" , "SVK" , "703" , "Slovakia (Slovak Republic)"                          ],
        "SL": [ "AF" , "SL" , "SLE" , "694" , "Sierra Leone, Republic of"                           ],
        "SM": [ "EU" , "SM" , "SMR" , "674" , "San Marino, Republic of"                             ],
        "SN": [ "AF" , "SN" , "SEN" , "686" , "Senegal, Republic of"                                ],
        "SO": [ "AF" , "SO" , "SOM" , "706" , "Somalia, Somali Republic"                            ],
        "SR": [ "SA" , "SR" , "SUR" , "740" , "Suriname, Republic of"                               ],
        "ST": [ "AF" , "ST" , "STP" , "678" , "Sao Tome and Principe, Democratic Republic of"       ],
        "SV": [ "NA" , "SV" , "SLV" , "222" , "El Salvador, Republic of"                            ],
        "SX": [ "NA" , "SX" , "SXM" , "534" , "Sint Maarten (Netherlands)"                          ],
        "SY": [ "AS" , "SY" , "SYR" , "760" , "Syrian Arab Republic"                                ],
        "SZ": [ "AF" , "SZ" , "SWZ" , "748" , "Swaziland, Kingdom of"                               ],
        "TC": [ "NA" , "TC" , "TCA" , "796" , "Turks and Caicos Islands"                            ],
        "TD": [ "AF" , "TD" , "TCD" , "148" , "Chad, Republic of"                                   ],
        "TF": [ "AN" , "TF" , "ATF" , "260" , "French Southern Territories"                         ],
        "TG": [ "AF" , "TG" , "TGO" , "768" , "Togo, Togolese Republic"                             ],
        "TH": [ "AS" , "TH" , "THA" , "764" , "Thailand, Kingdom of"                                ],
        "TJ": [ "AS" , "TJ" , "TJK" , "762" , "Tajikistan, Republic of"                             ],
        "TK": [ "OC" , "TK" , "TKL" , "772" , "Tokelau"                                             ],
        "TL": [ "AS" , "TL" , "TLS" , "626" , "Timor-Leste, Democratic Republic of"                 ],
        "TM": [ "AS" , "TM" , "TKM" , "795" , "Turkmenistan"                                        ],
        "TN": [ "AF" , "TN" , "TUN" , "788" , "Tunisia, Tunisian Republic"                          ],
        "TO": [ "OC" , "TO" , "TON" , "776" , "Tonga, Kingdom of"                                   ],
//        "TR": [ "AS" , "TR" , "TUR" , "792" , "Turkey, Republic of"                                 ],
        "TR": [ "EU" , "TR" , "TUR" , "792" , "Turkey, Republic of"                                 ],
        "TT": [ "NA" , "TT" , "TTO" , "780" , "Trinidad and Tobago, Republic of"                    ],
        "TV": [ "OC" , "TV" , "TUV" , "798" , "Tuvalu"                                              ],
        "TW": [ "AS" , "TW" , "TWN" , "158" , "Taiwan"                                              ],
        "TZ": [ "AF" , "TZ" , "TZA" , "834" , "Tanzania, United Republic of"                        ],
        "UA": [ "EU" , "UA" , "UKR" , "804" , "Ukraine"                                             ],
        "UG": [ "AF" , "UG" , "UGA" , "800" , "Uganda, Republic of"                                 ],
//        "UM": [ "NA" , "UM" , "UMI" , "581" , "United States Minor Outlying Islands"                ],
        "UM": [ "OC" , "UM" , "UMI" , "581" , "United States Minor Outlying Islands"                ],
        "US": [ "NA" , "US" , "USA" , "840" , "United States of America"                            ],
        "UY": [ "SA" , "UY" , "URY" , "858" , "Uruguay, Eastern Republic of"                        ],
        "UZ": [ "AS" , "UZ" , "UZB" , "860" , "Uzbekistan, Republic of"                             ],
        "VA": [ "EU" , "VA" , "VAT" , "336" , "Holy See (Vatican City State)"                       ],
        "VC": [ "NA" , "VC" , "VCT" , "670" , "Saint Vincent and the Grenadines"                    ],
        "VE": [ "SA" , "VE" , "VEN" , "862" , "Venezuela, Bolivarian Republic of"                   ],
        "VG": [ "NA" , "VG" , "VGB" , "92"  , "British Virgin Islands"                              ],
        "VI": [ "NA" , "VI" , "VIR" , "850" , "United States Virgin Islands"                        ],
        "VN": [ "AS" , "VN" , "VNM" , "704" , "Vietnam, Socialist Republic of"                      ],
        "VU": [ "OC" , "VU" , "VUT" , "548" , "Vanuatu, Republic of"                                ],
        "WF": [ "OC" , "WF" , "WLF" , "876" , "Wallis and Futuna"                                   ],
        "WS": [ "OC" , "WS" , "WSM" , "882" , "Samoa, Independent State of"                         ],
        "YE": [ "AS" , "YE" , "YEM" , "887" , "Yemen"                                               ],
        "YT": [ "AF" , "YT" , "MYT" , "175" , "Mayotte"                                             ],
        "ZA": [ "AF" , "ZA" , "ZAF" , "710" , "South Africa, Republic of"                           ],
        "ZM": [ "AF" , "ZM" , "ZMB" , "894" , "Zambia, Republic of"                                 ],
        "ZW": [ "AF" , "ZW" , "ZWE" , "716" , "Zimbabwe, Republic of"                               ]
    ]

}
