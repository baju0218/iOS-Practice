//
//  ButtonsStackView.swift
//  MyCalculator
//
//  Created by 백종운 on 2021/01/27.
//

import UIKit

class ButtonsStackView: UIStackView {
    func hiddenButtons(_ count: Int, _ set: Bool) {
        for i in 0..<count {
            self.subviews[i].isHidden = set
        }
    }
}
