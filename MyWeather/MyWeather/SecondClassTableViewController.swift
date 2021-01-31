//
//  SecondClassTableViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class SecondClassTableViewController: UITableViewController {
    //MARK: Properties
    var firstClass = ""
    var secondClass = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = firstClass
        secondClass = KoreaRegion.getSecondClass(firstClass) ?? []
        
        let nibName = UINib(nibName: "RegionWeatherTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "regionWeatherCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return secondClass.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 80
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionWeatherCell", for: indexPath) as? RegionWeatherTableViewCell

        let pos = KoreaRegion.getPosition(firstClass + " " + secondClass[indexPath.row])
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
        
        cell?.regionLabel.text = secondClass[indexPath.row]

        return cell!
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = firstClass
        
        if region != "세종특별자치시" { performSegue(withIdentifier: "secondToThird", sender: indexPath) }
        else { performSegue(withIdentifier: "secondToDetail", sender: indexPath) }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThirdClassTableViewController {
            if let indexPath = sender as? IndexPath {
                vc.firstClass = firstClass
                vc.secondClass = secondClass[indexPath.row]
            }
        }
        else if let vc = segue.destination as? DetailViewController {
            if let indexPath = sender as? IndexPath {
                vc.detailRegion = "세종특별자치시" + " " + secondClass[indexPath.row]
            }
        }
    }
}
