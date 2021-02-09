//
//  ViewController.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/03.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    // MARK : Models
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter
    }()
    var selectMenu: Bool! {
        didSet {
            if selectMenu {
                editButton.isHidden = false
                returnButton.isHidden = false
            }
            else {
                editButton.isHidden = true
                returnButton.isHidden = true
            }
        }
    }
    
    // MARK : Views
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memo: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // load data
        
        loadDaily(date: dateFormatter.string(from: datePicker.date))
    }
    
    override func viewDidLayoutSubviews() {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width { mainStackView.axis = .vertical }
        else { mainStackView.axis = .horizontal }
    }
    
    
    // MARK: - Data
    
    // Property
    var data = [String:Daily]()
    var daily: Daily!
    
    // Method
    private func loadDaily(date: String) {
        daily = data[date] ?? Daily(date: date)
        
        dateLabel.text = daily.date
        memo.text = daily.memo ?? Saying.getRandom()
        
        selectMenu = false
    }
    
    private func saveDaily() {
        daily.memo = memo.text
        data[daily.date] = daily
    }
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daily.toDo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "To Do Cell", for: indexPath)
        
        cell.textLabel?.text = daily.toDo[indexPath.row].text
        
        let time = daily.toDo[indexPath.row].time
        let hour = Int(time / 3600)
        let minute = Int(time / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        if hour == 0 && minute == 0 { cell.detailTextLabel?.text = String(format: "%d초", second) }
        else if hour == 0 { cell.detailTextLabel?.text = String(format: "%d분 %d초", minute, second) }
        else { cell.detailTextLabel?.text = String(format: "%d시간 %d분 %d초", hour, minute, second) }
        
        return cell
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Timer Segue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            daily.toDo.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: IBActions
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddToDoViewController {
            vc.delegate = self
        }
        if let vc = segue.destination as? TimerViewController {
            vc.delegate = self
            
            if let indexPath = sender as? IndexPath {
                vc.indexPath = indexPath
            }
        }
    }
    @IBAction func changeDate(_ sender: UIDatePicker) {
        saveDaily()
        loadDaily(date: dateFormatter.string(from: datePicker.date))
        tableView.reloadData()
    }
    
    @IBAction func touchAddButton(_ sender: UIButton) {
        if selectMenu == false {
            selectMenu = true
        }
        else {
            selectMenu = false
            performSegue(withIdentifier: "Add To Do Segue", sender: sender)
        }
    }
    
    @IBAction func touchEditButton(_ sender: UIButton) {
        selectMenu = false
        
        memo.isEditable = true
        memo.becomeFirstResponder()
    }
    
    @IBAction func touchReturnButton(_ sender: UIButton) {
        selectMenu = false
    }
    
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        memo.isEditable = false
        memo.resignFirstResponder()
    }
}
