//
//  EmptyView.swift
//  MyPhotos
//
//  Created by 백종운 on 2021/02/08.
//

import UIKit

class EmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let nib = UINib(nibName: "EmptyView", bundle: Bundle(for: type(of: self)))
        
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        view.backgroundColor = .orange
        self.addSubview(view)
        
        self.fr
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
