//
//  WeatherCell.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/31.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureHumidityLabel: UILabel!
    @IBOutlet weak var rainfallProbabilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func information(classification: Classification) {
        switch classification.weather.state() {
        case .Sunny:
            weatherImage.image = UIImage(named: "sunny")
        case .Cloudy:
            weatherImage.image = UIImage(named: "cloudy")
        case .Rainy:
            weatherImage.image = UIImage(named: "rainy")
        case .Snowy:
            weatherImage.image = UIImage(named: "snowy")
        default:
            break
        }
        
        locationLabel.text = classification.name
        if let temperature = classification.weather.temperature() {
            if let humidity = classification.weather.humidity() {
                temperatureHumidityLabel.text = "기온 : " + String(temperature) + "도 / " + "습도 : " + String(humidity) + "%"
            }
        }
        if let rainfallProbability = classification.weather.rainfallProbability() {
            rainfallProbabilityLabel.text = "강수확률 : " + String(rainfallProbability) + "%"
        }
    }
}
