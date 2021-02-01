//
//  Weather.swift
//  MyWeather
//
//  Created by 백종운 on 2021/02/01.
//

import Foundation

class Weather {
    var value = [String:String]()

    enum State {
        case Sunny
        case Cloudy
        case Rainy
        case Snowy
    }
    
    func state() -> State? {
        switch value["SKY"] {
        case "1":
            return .Sunny
        case "3", "4":
            switch value["PTY"] {
            case "0":
                return .Cloudy
            case "1", "4", "5":
                return .Rainy
            case "2", "3", "6", "7":
                return .Snowy
            default:
                print("weather error: invalid pty")
                print(value["SKY"] ?? "nil")
            }
        default:
            print("weather error: invalid sky")
            print(value["SKY"] ?? "nil")
        }
        
        return nil
    }
    
    func temperature() -> Double? {
        guard let temperatureString = value["T3H"] else { return nil }
        
        guard let temperature = Double(temperatureString) else { return nil }
        
        return temperature
    }
    
    func rainfallProbability() -> Int? {
        guard let rainfallProbabilityString = value["POP"] else { return nil }
        
        guard let rainfallProbability = Int(rainfallProbabilityString) else { return nil }
        
        return rainfallProbability
    }
    
    func humidity() -> Int? {
        guard let humidityString = value["REH"] else { return nil }
        
        guard let humidity = Int(humidityString) else { return nil }
        
        return humidity
    }
}
