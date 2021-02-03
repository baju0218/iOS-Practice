//
//  ViewController.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/03.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK : Models
    var toDoList = [ToDo]()
    
    // MARK : Views
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell", for: indexPath) as! TableViewCell
        
        cell.toDoTextLabel.text = toDoList[indexPath.row].text
        switch toDoList[indexPath.row].complete {
        case .None:
            cell.completeImage.image = UIImage(named: "None")
            cell.toDoTextLabel.textColor = .black
        case .Half:
            cell.completeImage.image = UIImage(named: "Half")
            cell.toDoTextLabel.textColor = .black
        case .Done:
            cell.completeImage.image = UIImage(named: "Done")
            cell.toDoTextLabel.textColor = .placeholderText
        default:
            break
        }
        
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = toDoList[indexPath.row]
        todo.updateComplete()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    // MARK: IBActions
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddToDoViewController {
            vc.delegate = self
        }
    }

}
