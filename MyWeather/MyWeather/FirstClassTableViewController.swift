//
//  FirstClassTableViewController.swift
//  MyWeather
//
//  Created by 백종운 on 2021/01/30.
//

import UIKit

class FirstClassTableViewController: UITableViewController {
    //MARK: Properties
    private var firstClasses = [Classification]()
    private var cities = [Classification]()
    private var provinces = [Classification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        firstClasses = AdministrativeDistrict.GetFirstClasses()
        cities = firstClasses.filter{ $0.name.hasSuffix("시") }
        provinces = firstClasses.filter{ $0.name.hasSuffix("도") }
        
        let nibName = UINib(nibName: "WeatherCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "weatherCell")
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
        if section == 0 { return cities.count }
        else { return provinces.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell
        let firstClass = indexPath.section == 0 ? cities[indexPath.row] : provinces[indexPath.row]
        
        cell!.information(classification: firstClass)
        
        return cell!
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstClass = indexPath.section == 0 ? cities[indexPath.row] : provinces[indexPath.row]
        
        if firstClass.nextClasses.isEmpty { performSegue(withIdentifier: "firstClassToDetail", sender: firstClass) }
        else { performSegue(withIdentifier: "firstClassToSecondClass", sender: firstClass) }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "firstClassToDetail":
            guard let vc = segue.destination as? DetailViewController else {
                print("prepare error: fail to convert viewController")
                print(segue.destination)
                return
            }
            
            guard let firstClass = sender as? Classification else {
                print("prepare error: fail to convert classification")
                return
            }
            
            vc.firstClassName = firstClass.name
            vc.classification = firstClass
        case "firstClassToSecondClass":
            guard let vc = segue.destination as? SecondClassTableViewController else {
                print("prepare error: fail to convert viewController")
                print(segue.destination)
                return
            }
            
            guard let firstClass = sender as? Classification else {
                print("prepare error: fail to convert classification")
                return
            }
            
            vc.firstClassName = firstClass.name
            vc.secondClasses = firstClass.nextClasses
        default:
            print("prepare error: invalid segue")
            print(segue)
            return
        }
    }
}
