//
//  HomeViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Current Time Properties
    var timer: Timer?
    var currentTimeBlink = true
    let currentTimeFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a h : MM"
        return formatter
    }()
    let currentTimeFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a h   MM"
        return formatter
    }()
    
    //MARK: Update Properties
    var updateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    //MARK: IBOutlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentRegionView: UIStackView!
    @IBOutlet weak var currentRegionLabel: UILabel!
    @IBOutlet weak var currentRegionState: UILabel!
    @IBOutlet weak var currentRegionTemperature: UILabel!
    @IBOutlet weak var currentRegionHumidity: UILabel!
    @IBOutlet weak var recentUpdateLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateLoading: UIActivityIndicatorView!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    //MARK: Methods
    private func setupUI() {
        // Selected Region UI
        if UserData.CurrentRegion != nil {
            
            // 현재 위치 처리
            
        }
        currentRegionView.layer.cornerRadius = 16
        currentRegionView.layer.backgroundColor = CGColor(red: 0, green: 0.5, blue: 1, alpha: 0.5)
        
        // Update UI
        if UserData.RecentUpdate != nil {
            recentUpdateLabel.text = updateFormatter.string(from: UserData.RecentUpdate!)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        updateButton.isHidden = false
        updateLoading.stopAnimating()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let blink = self?.currentTimeBlink else { return }
            
            if blink { self?.currentTime.text = self?.currentTimeFormatter1.string(from: Date()) }
            else { self?.currentTime.text = self?.currentTimeFormatter2.string(from: Date()) }
            
            self?.currentTimeBlink = !(self?.currentTimeBlink ?? true)
        }
        timer?.fire()
    }
    
    //MARK: IBActions
    @IBAction func touchUpUpdateButton(_ sender: UIButton) {
        updateButton.isHidden = true
        updateLoading.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            RegionWeather.Update()
            
            DispatchQueue.main.async { [weak self] in
                UserData.RecentUpdate = Date()
                self?.setupUI()
            }
        }
    }
}
