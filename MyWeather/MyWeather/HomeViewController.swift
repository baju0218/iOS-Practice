//
//  HomeViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Current Time Properties
    var currentTimeTimer: Timer?
    var currentTimeBlink = true
    let currentTimeFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a h : mm"
        return formatter
    }()
    let currentTimeFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a h   mm"
        return formatter
    }()
    
    //MARK: Update Weather Properties
    var updateWeatherFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    //MARK: IBOutlets
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var userWeatherView: UIStackView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userTemperatureLabel: UILabel!
    @IBOutlet weak var userHumidityLabel: UILabel!
    @IBOutlet weak var userRainfallProbabilityLabel: UILabel!
    
    @IBOutlet weak var weatherUpdateLabel: UILabel!
    @IBOutlet weak var weatherUpdateButton: UIButton!
    @IBOutlet weak var weatherUpdateLoading: UIActivityIndicatorView!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCurrentTimeTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentTimeTimer!.invalidate()
    }
    
    //MARK: Methods
    private func setupUI() {
        // User Weather UI
        userWeatherView.layer.cornerRadius = 16
        userWeatherView.layer.backgroundColor = CGColor(red: 0, green: 0.5, blue: 1, alpha: 0.5)
        
        if let weather = AdministrativeDistrict.Korea?.nextClasses.first?.weather {
            switch weather.state() {
            case .Sunny:
                backgroundImage.image = UIImage(named: "sunny_bg")
                backgroundImage.contentMode = .scaleToFill
            case .Cloudy:
                backgroundImage.image = UIImage(named: "cloudy_bg")
                backgroundImage.contentMode = .scaleToFill
            case .Rainy:
                backgroundImage.image = UIImage(named: "rainy_bg")
                backgroundImage.contentMode = .scaleToFill
            case .Snowy:
                backgroundImage.image = UIImage(named: "snowy_bg")
                backgroundImage.contentMode = .scaleToFill
            default:
                break
            }
            
            if let temperature = weather.temperature() { userTemperatureLabel.text = String(temperature) + "도" }
            if let humiditiy = weather.humidity() { userHumidityLabel.text = String(humiditiy) + "%" }
            if let rainfallProbability = weather.rainfallProbability() { userRainfallProbabilityLabel.text = "강수 확률 : " + String(rainfallProbability) + "%" }
        }
        
        // Weather Update UI
        if WeatherAPI.recentUpdateDate != nil {
            weatherUpdateLabel.text = updateWeatherFormatter.string(from: WeatherAPI.recentUpdateDate!)
            navigationItem.rightBarButtonItem!.isEnabled = true
        }
        
        weatherUpdateButton.isHidden = false
        weatherUpdateLoading.stopAnimating()
    }
    
    private func setupCurrentTimeTimer() {
        currentTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let vc = self else { return }
            
            if vc.currentTimeBlink { vc.currentTime.text = vc.currentTimeFormatter1.string(from: Date()) }
            else { vc.currentTime.text = vc.currentTimeFormatter2.string(from: Date()) }
            
            vc.currentTimeBlink = !vc.currentTimeBlink
        }
        
        currentTimeTimer!.fire()
    }
    
    //MARK: IBActions
    @IBAction func touchUpWeatherUpdateButton(_ sender: UIButton) {
        weatherUpdateButton.isHidden = true
        weatherUpdateLoading.startAnimating()
        navigationItem.rightBarButtonItem!.isEnabled = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            let currentDate = Date()
            
            
            
            WeatherAPI.Update(classification: AdministrativeDistrict.Korea!)
            // 업데이트 갯수 세기
            
            
            
            DispatchQueue.main.async { [weak self] in
                WeatherAPI.recentUpdateDate = Date()
                self?.setupUI()
            }
        }
    }
}
