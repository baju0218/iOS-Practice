//
//  TimerViewController.swift
//  MyToDoList
//
//  Created by 백종운 on 2021/02/10.
//

import UIKit

class TimerViewController: UIViewController {

    weak var delegate: ViewController?
    var indexPath: IndexPath!
    
    private var timer: Timer?
    private var time: TimeInterval! {
        didSet {
            let hour = Int(time / 3600)
            let minute = Int(time / 60)
            let second = Int(time.truncatingRemainder(dividingBy: 60))
            
            hourLabel.text = String(format: "%02d", hour)
            minuteLabel.text = String(format: "%02d", minute)
            secondLabel.text = String(format: "%02d", second)
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        textLabel.text = delegate!.daily.toDo[indexPath.row].text
        time = delegate!.daily.toDo[indexPath.row].time
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func startButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                guard let vc = self else { return }
                
                vc.time = vc.time + 0.01
            }
            
            timer?.fire()
        }
        else {
            timer?.invalidate()
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        timer?.invalidate()
        
        self.navigationController?.popViewController(animated: true)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        delegate?.daily.toDo[indexPath.row].time = time
        delegate?.tableView.reloadData()
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        time = 0
    }
}
