//
//  ToDo.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/03.
//

import Foundation

enum Complete {
    case None
    case Half
    case Done
}

class ToDo {
    var text: String = ""
    var time: TimeInterval = 0
    var complete: Complete = .None
    
    init(text: String, time: TimeInterval, complete: Complete) {
        self.text = text
        self.time = time
        self.complete = complete
    }
    
    func updateComplete() {
        switch complete {
        case .None:
            complete = .Half
        case .Half:
            complete = .Done
        case .Done:
            complete = .None
        }
    }
}
