//
//  ViewController.swift
//  MyLaboratory
//
//  Created by 백종운 on 2021/02/07.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)).then {
            
        }
    }
    
}
