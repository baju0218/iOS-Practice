//
//  AllPhotosCollectionViewCell.swift
//  MyPhotos
//
//  Created by 백종운 on 2021/02/08.
//

import UIKit

class AllPhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    var id: String?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var checkMarkView: UIImageView!
}
