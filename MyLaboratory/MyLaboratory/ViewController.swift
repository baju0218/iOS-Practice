//
//  ViewController.swift
//  MyLaboratory
//
//  Created by 백종운 on 2021/01/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func test() {
        var temp = customView()
        
        view.addSubview(temp)
    }
}

class customView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame이 사용됨")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder가 사용됨")
    }
}
