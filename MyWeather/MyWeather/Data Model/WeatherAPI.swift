//
//  WeatherAPI.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/31.
//

import Foundation

struct WeatherURL {// URL
    static var url = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtNcst?serviceKey=R6kCK16zNse2c9K4hUpP%2FaG5A5ktXcPfg3fFM9ZQA7xY%2FP6GLvu6eYEhS86wYcZt2BEzLIOgcIVhZNRe1FXvzA%3D%3D&pageNo=1&numOfRows=8&dataType=JSON"
    static var date = "&base_date="
    static var time = "&base_time="
    static var nx = "&nx="
    static var ny = "&ny="
}

struct WeatherAPI: Codable {
    // JSON
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
                    var nx: Int
                    var ny: Int
                    var obsrValue: String
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
        var body: Body
    }
    
    var response: Response
    
    //MARK: Methods
    static func Load(_ nx: Int, _ ny: Int) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYYMMDD"
        let date = formatter.string(from: Date())
        formatter.dateFormat = "HH00"
        let time = formatter.string(from: Date(timeInterval: -3600, since: Date()))
        
        let urlString = WeatherURL.url + WeatherURL.date + date + WeatherURL.time + time + WeatherURL.nx + String(nx) + WeatherURL.ny + String(ny)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(WeatherAPI.self, from: data)
                    
                    let key = String(nx) + " " + String(ny)
                    
                    var result = WeatherInfo()
                    
                    for item in jsonData.response.body.items.item {
                        switch item.category {
                        case "T1H":
                            result.temperature = Double(item.obsrValue)
                        case "RN1":
                            result.rainfall = Double(item.obsrValue)
                        case "REH":
                            result.humidity = Double(item.obsrValue)
                        case "PTY":
                            result.type = Int(item.obsrValue)
                        case "VEC":
                            result.direction = Double(item.obsrValue)
                        case "WSD":
                            result.velocity = Double(item.obsrValue)
                        default:
                            break
                        }
                    }
                    
                    RegionWeather.Data[key] = result
                } catch let error {
                    print(String(data:data, encoding: .utf8 ) )
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
