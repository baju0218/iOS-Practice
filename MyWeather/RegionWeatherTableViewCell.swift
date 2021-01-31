//
//  RegionWeatherTableViewCell.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/31.
//

import UIKit

class RegionWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
