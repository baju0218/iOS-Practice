//
//  WeatherAPI.swift
//  MyWeather
//
//  Created by 백종운 on 2021/02/01.
//

import Foundation

struct JsonData: Codable {
    struct Response: Codable {
        struct Header: Codable {
            var resultCode: String
            var resultMsg: String
        }
        
        struct Body: Codable {
            struct Items: Codable {
                struct Item: Codable {
                    var baseDate: String
                    var baseTime: String
                    var category: String
                    var fcstDate: String
                    var fcstTime: String
                    var fcstValue: String
                    var nx: Int
                    var ny: Int
                }
                
                var item: [Item]
            }
            
            var dataType: String
            var items: Items
            var pageNo: Int
            var numOfRows: Int
            var totalCount: Int
        }
        
        var header: Header
        var body: Body?
    }
    
    var response: Response
}

class WeatherAPI {
    // Recent Update Date
    static var recentUpdateDate: Date?
    
    // Update Weather
    static func Update(classification: Classification) {
        Request(classification: classification)
        
        // DFS
        for nextClass in classification.nextClasses {
            Update(classification: nextClass)
        }
    }
    
    static func Request(classification: Classification) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmm"
        
        // Make base time
        let date = Date(timeIntervalSinceNow: -900)
        var dateString = dateFormatter.string(from: date)
        var timeString = timeFormatter.string(from: date)
        
        let hour = Int(timeFormatter.string(from: date))! / 100
        if hour < 2 {
            dateString = dateFormatter.string(from: date.addingTimeInterval(-24 * 3600))
            timeString = "2300"
        }
        else if 2 <= hour && hour < 5 { timeString = "0200" }
        else if 5 <= hour && hour < 8 { timeString = "0500" }
        else if 8 <= hour && hour < 11 { timeString = "0800" }
        else if 11 <= hour && hour < 14 { timeString = "1100" }
        else if 14 <= hour && hour < 17 { timeString = "1400" }
        else if 17 <= hour && hour < 20 { timeString = "1700" }
        else if 20 <= hour && hour < 23 { timeString = "2000" }
        else if 23 <= hour { timeString = "2300" }
        
        let nx = String(classification.coordinate.0)
        let ny = String(classification.coordinate.1)
        
        
        
        
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=R6kCK16zNse2c9K4hUpP%2FaG5A5ktXcPfg3fFM9ZQA7xY%2FP6GLvu6eYEhS86wYcZt2BEzLIOgcIVhZNRe1FXvzA%3D%3D&pageNo=1&numOfRows=14&dataType=JSON&base_date=" + dateString + "&base_time=" + timeString + "&nx=" + nx + "&ny=" + ny
        
        guard let url = URL(string: urlString) else {
            print("request error: invalid url")
            print(urlString)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("request error: fail to get data")
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(JsonData.self, from: data)
                    
                    if jsonData.response.header.resultCode != "00" {
                        print("request error: receive error code")
                        print(jsonData.response.header.resultMsg)
                        print(urlString)
                        return
                    }
                    
                    classification.weather = Weather()
                    
                    for item in jsonData.response.body!.items.item {
                        if classification.weather.value[item.category] == nil {
                            classification.weather.value[item.category] = item.fcstValue
                        }
                    }
                } catch let error {
                    print("fail to decode data")
                    print(error.localizedDescription)
                    print(urlString)
                }
            }
        }.resume()
    }
}
