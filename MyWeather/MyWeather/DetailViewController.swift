//
//  DetailViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class DetailViewController: UIViewController {
    var detailRegion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = detailRegion
    }
}
