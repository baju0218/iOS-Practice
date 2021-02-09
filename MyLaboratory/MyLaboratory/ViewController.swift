//
//  ViewController.swift
//  MyLaboratory
//
//  Created by 백종운 on 2021/02/07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpInsideButton(_ sender: UIButton) {
        let textToShare: String = "안녕하세요, 부스트 코스입니다."
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: [])
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
