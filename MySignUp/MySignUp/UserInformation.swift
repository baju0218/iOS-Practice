//
//  File.swift
//  MySignUp
//
//  Created by 백종운 on 2021/01/27.
//

import UIKit

class UserInformation {
    static var userInformation: UserInformation?
    
    //MARK: Properties
    var id: String
    var password: String
    var image: UIImage?
    var introduce: String?
    var telephoneNumber: String
    var birthDay: Date
    
    //MARK: Initialization
    init(id: String, password: String, image: UIImage?, introduce: String?, telephoneNumber: String, birthDay: Date) {
        // Initialize stored properties.
        self.id = id
        self.password = password
        self.image = image
        self.introduce = introduce
        self.telephoneNumber = telephoneNumber
        self.birthDay = birthDay
    }
}
