//
//  ViewController.swift
//  MyMusicPlayer
//
//  Created by 백종운 on 2021/01/25.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioPlayerDelegate {
    //MARK: Properties
    private var player: AVAudioPlayer!
    private var timer: Timer!
    
    //MARK: IBOutlets
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializePlayer()
    }
    
    //MARK: Methods
    private func initializePlayer() {
        guard let soundAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다.")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    private func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [unowned self] (timer: Timer) in
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        }
        
        self.timer.fire()
    }
    
    private func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    private func updateTimeLabelText(time: TimeInterval) {
        let minute = Int(time / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        self.timeLabel.text = String(format: "%02d:%02d:%02d", minute, second, milisecond)
    }
    
    //MARK: IBActions
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.makeAndFireTimer()
        }
        else {
            self.player?.pause()
            self.invalidateTimer()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        
        if sender.isTracking { return }
        
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    //MARK: AVAudioPlayerDelegates
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류 발생")
            return
        }
        
        let message = "오디어 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {_ in 
            self.dismiss(animated: true, completion: nil)
        }
    
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.invalidateTimer()
        
        self.playPauseButton.isSelected = false
        self.updateTimeLabelText(time: 0)
        self.progressSlider.value = 0
    }
}

