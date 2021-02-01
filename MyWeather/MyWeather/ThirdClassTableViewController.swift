//
//  ThirdClassTableViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class ThirdClassTableViewController: UITableViewController {

    //MARK: Properties
    var firstClassName = ""
    var secondClassName = ""
    var thirdClasses = [Classification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = firstClassName + " " + secondClassName
        
        let nibName = UINib(nibName: "WeatherCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "weatherCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thirdClasses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell
        let thirdClass = thirdClasses[indexPath.row]
        
        cell!.information(classification: thirdClass)
        
        return cell!
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thirdClass = thirdClasses[indexPath.row]
        
        performSegue(withIdentifier: "thirdClassToDetail", sender: thirdClass)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "thirdClassToDetail":
            guard let vc = segue.destination as? DetailViewController else {
                print("prepare error: fail to convert viewController")
                print(segue.destination)
                return
            }
            
            guard let thirdClass = sender as? Classification else {
                print("prepare error: fail to convert classification")
                return
            }
            
            vc.firstClassName = firstClassName
            vc.secondClassName = secondClassName
            vc.thirdClassName = thirdClass.name
            vc.classification = thirdClass
        default:
            print("prepare error: invalid segue")
            print(segue)
            return
        }
    }
}
