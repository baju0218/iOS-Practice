//
//  RegionWeather.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import Foundation

struct WeatherInfo {
    var temperature: Double?
    var humidity: Double?
    var type: Int?
    var rainfall: Double?
    var direction: Double?
    var velocity: Double?
}

class RegionWeather {
    static var Data = [String : WeatherInfo]()
    
    static func Update() {
        for (nx, ny) in KoreaRegion.ValidPosition {
            WeatherAPI.Load(nx, ny)
        }
    }
    
    static func Info(_ nx: Int, _ ny: Int) -> WeatherInfo? {
        let key = String(nx) + " " + String(ny)
        
        return Data[key]
    }
}
