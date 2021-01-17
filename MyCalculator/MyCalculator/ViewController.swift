//
//  ViewController.swift
//  MyCalculator
//
//  Created by 백종운 on 2021/01/15.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    private var calculator = Calculator()
    private var isUserTypingNumber = false

    //MARK: IBOutlets
    @IBOutlet weak var body: UIStackView!
    @IBOutlet weak var radian: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        body.layer.cornerRadius = 16
        body.layer.masksToBounds = true
    }

    //MARK: IBActions
    @IBAction func pressClearButton() {
        switch clearButton.currentTitle {
        case "AC":
            calculator.performClear()
            isUserTypingNumber = false
            display.text = String(0)
        case "C":
            isUserTypingNumber = false
            display.text = String(0)
            clearButton.setTitle("AC", for: UIControl.State.normal)
        default:
            print("Error in pressClearButton : Invalid clear " + (clearButton.currentTitle ?? "nil"))
        }
    }
    
    @IBAction func pressNumberButton(_ sender: UIButton) {
        if isUserTypingNumber {
            switch sender.currentTitle {
            case ".":
                if display.text!.contains(Character(".")) {
                    break
                }
                else {
                    display.text! += sender.currentTitle!
                }
            default:
                if display.text == "0" {
                    display.text = sender.currentTitle!
                }
                else {
                    display.text! += sender.currentTitle!
                }
            }
        }
        else {
            switch sender.currentTitle {
            case ".":
                display.text = "0"
            default:
                display.text = ""
            }
            
            isUserTypingNumber = true
            display.text! += sender.currentTitle!
            clearButton.setTitle("C", for: UIControl.State.normal)
        }
    }
    
    @IBAction func pressOperationButton(_ sender: UIButton) {
        var result: Double
        
        // Perform operation
        do {
            result = try calculator.performOperation(number: display.text, symbol: sender.currentTitle)
        }
        catch CalculatorError.invalidValue(let number) {
            print("Error in pressOperationButton: Invalid value " + number)
            return
        }
        catch CalculatorError.invalidOperation(let symbol) {
            print("Error in pressOperationButton: Invalid operation " + symbol)
            return
        }
        catch {
            print("Error in pressOperationButton: ")
            return
        }
        
        isUserTypingNumber = false
        if result.isNaN {
            display.text = "nan"
        }
        else if result.isInfinite {
            display.text = "infinity"
        }
        else if result == floor(result) {
            display.text = String(format: "%.0lf", result)
        }
        else {
            display.text = String(result)
        }
        clearButton.setTitle("C", for: UIControl.State.normal)
    }
    
    @IBAction func pressChangeButton(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Rad":
            radian.text = "Rad"
            sender.setTitle("Deg", for: UIControl.State.normal)
        case "Deg":
            radian.text = ""
            sender.setTitle("Rad", for: UIControl.State.normal)
        case "2nd":
            break
        default:
            print("Error in pressChangeButton: ")
        }
    }
}
