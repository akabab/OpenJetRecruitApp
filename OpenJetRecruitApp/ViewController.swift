//
//  ViewController.swift
//  OpenJetRecruitApp
//
//  Created by Yoann Cribier on 15/12/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = "http://middle.openjetlab.fr/api/rests/airport/list"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fetchAirports();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchAirports() {
        let request = HTTP.formatGetRequest(url)
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            print(data)
        }
    }

}

