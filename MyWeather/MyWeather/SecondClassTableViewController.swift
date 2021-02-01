//
//  SecondClassTableViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class SecondClassTableViewController: UITableViewController {
    //MARK: Properties
    var firstClassName = ""
    var secondClasses = [Classification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = firstClassName
        
        let nibName = UINib(nibName: "WeatherCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "weatherCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondClasses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell
        let secondClass = secondClasses[indexPath.row]
        
        cell!.information(classification: secondClass)
        
        return cell!
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondClass = secondClasses[indexPath.row]
        
        if secondClass.nextClasses.isEmpty { performSegue(withIdentifier: "secondClassToDetail", sender: secondClass) }
        else { performSegue(withIdentifier: "secondClassToThirdClass", sender: secondClass) }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "secondClassToDetail":
            guard let vc = segue.destination as? DetailViewController else {
                print("prepare error: fail to convert viewController")
                print(segue.destination)
                return
            }
            
            guard let secondClass = sender as? Classification else {
                print("prepare error: fail to convert classification")
                return
            }
            
            vc.firstClassName = firstClassName
            vc.secondClassName = secondClass.name
            vc.classification = secondClass
        case "secondClassToThirdClass":
            guard let vc = segue.destination as? ThirdClassTableViewController else {
                print("prepare error: fail to convert viewController")
                print(segue.destination)
                return
            }
            
            guard let secondClass = sender as? Classification else {
                print("prepare error: fail to convert classification")
                return
            }
            
            vc.firstClassName = firstClassName
            vc.secondClassName = secondClass.name
            vc.thirdClasses = secondClass.nextClasses
        default:
            print("prepare error: invalid segue")
            print(segue)
            return
        }
    }
}
