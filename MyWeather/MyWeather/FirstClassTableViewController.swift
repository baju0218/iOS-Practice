//
//  FirstClassTableViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class FirstClassTableViewController: UITableViewController {
    //MARK: Properties
    private var firstClass = [String]()
    private var city = [String]()
    private var province = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        firstClass = KoreaRegion.getFirstClass()
        city = firstClass.filter{$0.hasSuffix("시")}
        province = firstClass.filter{$0.hasSuffix("도")}
        
        let nibName = UINib(nibName: "RegionWeatherTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "regionWeatherCell")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "도시" }
        else { return "지방" }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return city.count }
        else { return province.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 80
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionWeatherCell", for: indexPath) as? RegionWeatherTableViewCell

        if indexPath.section == 0 {
            let pos = KoreaRegion.getPosition(city[indexPath.row])
            if let info = RegionWeather.Info(pos!.0, pos!.1) {
                cell?.weatherInfoLabel.text = "기온 : " + String(Int(info.temperature ?? 0)) + "도 / 습도 : " + String(Int(info.humidity ?? 0)) + "%"
                
                switch info.type {
                case 0:
                    cell?.weatherImage.image = UIImage(named: "sunny")
                case 1, 4, 5:
                    cell?.weatherImage.image = UIImage(named: "rainy")
                case 2, 6:
                    cell?.weatherImage.image = UIImage(named: "cloudy")
                case 3, 7:
                    cell?.weatherImage.image = UIImage(named: "snowy")
                default:
                    break
                }
            }
            
            cell?.regionLabel.text = city[indexPath.row]
        }
        else {
            let pos = KoreaRegion.getPosition(province[indexPath.row])
            if let info = RegionWeather.Info(pos!.0, pos!.1) {
                cell?.weatherInfoLabel.text = "기온 : " + String(Int(info.temperature ?? 0)) + "도 / 습도 : " + String(Int(info.humidity ?? 0)) + "%"
                
                switch info.type {
                case 0:
                    cell?.weatherImage.image = UIImage(named: "sunny")
                case 1, 4, 5:
                    cell?.weatherImage.image = UIImage(named: "rainy")
                case 2, 6:
                    cell?.weatherImage.image = UIImage(named: "cloudy")
                case 3, 7:
                    cell?.weatherImage.image = UIImage(named: "snowy")
                default:
                    break
                }
            }
            
            cell?.regionLabel.text = province[indexPath.row]
            
        }

        return cell!
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = indexPath.section == 0 ? city[indexPath.row] : province[indexPath.row]
        
        if region != "이어도" { performSegue(withIdentifier: "firstToSecond", sender: indexPath) }
        else { performSegue(withIdentifier: "firstToDetail", sender: indexPath) }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SecondClassTableViewController {
            if let indexPath = sender as? IndexPath {
                if indexPath.section == 0 { vc.firstClass = city[indexPath.row] }
                else { vc.firstClass = province[indexPath.row] }
            }
        }
        else if let vc = segue.destination as? DetailViewController {
            vc.detailRegion = "이어도"
        }
    }
}
