//
//  SignUpViewController.swift
//  MySignUp
//
//  Created by 백종운 on 2021/01/27.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userPassword1: UITextField!
    @IBOutlet weak var userPassword2: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var introduceView: UIStackView!
    @IBOutlet weak var userIntroduction: UITextView!
    
    @IBOutlet weak var nextSignUpButton: UIBarButtonItem!
    
    //MARK: Lift Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        userId.delegate = self
        userPassword1.delegate = self
        userPassword2.delegate = self
    }
    
    //MARK: Methods
    private func updateUI() {
        introduceView.layer.cornerRadius = 16
    }
    
    //MARK: IBActions
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newId = userId.text ?? ""
        var newPassword1 = userPassword1.text ?? ""
        var newPassword2 = userPassword2.text ?? ""
        
        switch textField {
        case userId:
            if string.isEmpty && !newId.isEmpty { newId.removeLast() }
            else { newId += string }
        case userPassword1:
            if string.isEmpty && !newPassword1.isEmpty { newPassword1.removeLast() }
            else { newPassword1 += string }
        default:
            if string.isEmpty && !newPassword2.isEmpty { newPassword2.removeLast() }
            else { newPassword2 += string }
        }
        
        // Maximum id/password length
        if newId.count > 12 || newPassword1.count > 12 || newPassword2.count > 12 { return false }
        
        // if length is 4~12 of both text then enable sign in button
        if newId.count > 3 && newPassword1.count > 3 && newPassword1 == newPassword2 { nextSignUpButton.isEnabled = true }
        else { nextSignUpButton.isEnabled = false }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userId:
            userPassword1.becomeFirstResponder()
        case userPassword1:
            userPassword2.becomeFirstResponder()
        default:
            userPassword2.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: UIImagePickerControllerDelegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImage.image = info[.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
}
