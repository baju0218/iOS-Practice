//
//  DetailSignUpViewController.swift
//  MySignUp
//
//  Created by 백종운 on 2021/01/27.
//

import UIKit

class DetailSignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var telephoneNumber: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    
    @IBOutlet weak var completeSignUpButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telephoneNumber.delegate = self
        birthday.maximumDate = Date()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: IBActions
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func touchUpCompleteSignInButton(_ sender: UIBarButtonItem) {
        guard let signUpViewController = navigationController?.viewControllers[1] as? SignUpViewController else {
            return
        }
        
        UserInformation.userInformation = UserInformation(id: signUpViewController.userId.text!, password: signUpViewController.userPassword1.text!, image: signUpViewController.userImage.image, introduce: signUpViewController.userIntroduction.text, telephoneNumber: telephoneNumber.text!, birthDay: birthday.date)
        
        let alert = UIAlertController(title: "회원가입 완료", message: "축하합니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: false)
        })
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newTelephoneNumber = telephoneNumber.text ?? ""
        
        if string.isEmpty && !newTelephoneNumber.isEmpty { newTelephoneNumber.removeLast() }
        else { newTelephoneNumber += string }
        
        if newTelephoneNumber.count > 11 { return false }
        
        // if length is 4~12 of both text then enable sign in button
        if newTelephoneNumber.count > 6 { completeSignUpButton.isEnabled = true }
        else { completeSignUpButton.isEnabled = false }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
