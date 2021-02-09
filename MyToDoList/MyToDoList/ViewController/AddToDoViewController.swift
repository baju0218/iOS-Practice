//
//  AddToDoViewController.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/04.
//

import UIKit

class AddToDoViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: ViewController?
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        
        textField.delegate = self
        textField.isHidden = true
        textField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appearedKeyboard(_ :)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func appearedKeyboard(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            textField.isHidden = false
            
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height - keyboardHeight - textField.frame.height).isActive = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.dismiss(animated: true)
        
        if let vc = self.delegate {
            let inputText = textField.text ?? ""
            
            if inputText.isEmpty { return }
            
            vc.daily.toDo.append(ToDo(text: textField.text ?? "", time: TimeInterval(0), complete: .None))
            
            let newIndexPath = IndexPath(row: vc.daily.toDo.count - 1, section: 0)
            
            vc.tableView.insertRows(at: [newIndexPath], with: .none)
        }
    }
    
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
