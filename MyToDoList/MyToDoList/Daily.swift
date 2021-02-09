//
//  Daily.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/10.
//

import Foundation

class Daily {
    var date: String
    var memo: String?
    var toDo: [ToDo]
    
    init(date: String) {
        self.date = date
        self.toDo = [ToDo]()
    }
}
