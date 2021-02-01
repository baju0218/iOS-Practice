//
//  DetailViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: Properties
    var firstClassName = ""
    var secondClassName = ""
    var thirdClassName = ""
    var classification: Classification?
    
    //MARK: IBOutlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainfallProbabilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var title = firstClassName
        if secondClassName != "" { title += " " + secondClassName }
        if thirdClassName != "" { title += " " + thirdClassName }
        
        self.navigationItem.title = title
        
        locationLabel.text = String(title.split(separator: " ").last!)
        
        if let weather = classification?.weather {
            switch weather.state() {
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
            
            if let temperature = weather.value["T3H"] { temperatureLabel.text = temperature + "도" }
            if let minTemperature = weather.value["TMN"] { minTemperatureLabel.text = minTemperature + "도" }
            if let maxperature = weather.value["TMX"] { maxTemperatureLabel.text = maxperature + "도" }
            if let humidity = weather.value["REH"] { humidityLabel.text = humidity + "%" }
            if let rainfallProbability = weather.value["POP"] { rainfallProbabilityLabel.text = rainfallProbability + "%" }
        }
    }
}
