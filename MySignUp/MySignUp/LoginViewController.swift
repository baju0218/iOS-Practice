//
//  LoginViewController.swift
//  MySignUp
//
//  Created by 백종운 on 2021/01/26.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId.delegate = self
        userPassword.delegate = self
    }
    
    //MARK: IBActions
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextFieldDelegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newId = userId.text ?? ""
        var newPassword = userPassword.text ?? ""
        
        switch textField {
        case userId:
            if string.isEmpty && !newId.isEmpty { newId.removeLast() }
            else { newId += string }
        default:
            if string.isEmpty && !newPassword.isEmpty { newPassword.removeLast() }
            else { newPassword += string }
        }
        
        // Maximum id/password length
        if newId.count > 12 || newPassword.count > 12 { return false }
        
        // if length is 4~12 of both text then enable sign in button
        if newId.count > 3 && newPassword.count > 3 { signInButton.isEnabled = true }
        else { signInButton.isEnabled = false }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userId:
            userPassword.becomeFirstResponder()
        default:
            userPassword.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: IBActions
    @IBAction func touchUpSignIn(_ sender: UIButton) {
        var title: String
        var message: String
        
        if let userInformation = UserInformation.userInformation {
            if userInformation.id == userId.text && userInformation.password == userPassword.text {
                title =  "로그인 성공"
                message = "축하합니다"
            }
            else {
                title =  "로그인 실패"
                message = "아이디 또는 비밀번호를 확인하세요"
            }
        }
        else {
            title =  "로그인 실패"
            message = "회원가입을 먼저 해주세요"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
