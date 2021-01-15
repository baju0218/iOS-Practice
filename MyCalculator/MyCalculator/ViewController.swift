//
//  ViewController.swift
//  MyCalculator
//
//  Created by 백종운 on 2021/01/15.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    private var model = Model()
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    //MARK: IBOutlets
    @IBOutlet weak var display: UILabel!
    
    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: IBActions
    @IBAction private func pressDigit(_ sender: UIButton) {
        if displayValue == 0 {
            display.text = sender.currentTitle!
        }
        else {
            display.text = display.text! + sender.currentTitle!
        }
    }
    @IBAction func pressOperation(_ sender: UIButton) {
        
    }
}

