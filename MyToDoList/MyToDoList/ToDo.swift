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
    var text: String
    var complete: Complete
    
    init(text: String, complete: Complete) {
        self.text = text
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
        default:
            break
        }
    }
}
