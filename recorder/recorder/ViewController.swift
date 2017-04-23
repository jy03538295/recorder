//
//  ViewController.swift
//  recorder
//
//  Created by Dongsheng He on 2017/4/23.
//  Copyright © 2017年 Dongsheng He. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {

    var recorder:AVAudioRecorder?
    var dic:[String:Any]?
    var currentRecordFileName:String?
    var recordFilesPath:String?
    
    var player:AVAudioPlayer?
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().requestRecordPermission { (permission) in
        }
        
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! AVAudioSession.sharedInstance().setActive(true)

        
        recordFilesPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
        
        dic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0
        ]
        
        playBtn.setTitleColor(UIColor.gray, for: .disabled)
        
        let button = UIButton.init(type: .custom)
        button.setTitle("录音菜单", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 80, height: 30)
        button.addTarget(self, action: #selector(ViewController.recordsMenuButtonTapped), for: .touchUpInside)
        let buttonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.setRightBarButton(buttonItem, animated: true)
        
        var fileNames = UserDefaults.standard.array(forKey: "myFileNames") as? [String]
        
        if fileNames == nil || fileNames?.count == 0{
            playBtn.isEnabled = false
        }
        
    }
    
    func recordsMenuButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "recordTable") as! RecordsListViewController
        vc.recordFilesPath = recordFilesPath
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func PressDown(_ sender: Any) {
            let date = Date()
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:SS"
            
            var fileNames = UserDefaults.standard.array(forKey: "myFileNames") as? [String] ?? [String]()
            
            currentRecordFileName = dateFormatter.string(from: date) + ".acc"
            fileNames.append(currentRecordFileName!)
            let path = recordFilesPath! + currentRecordFileName!
            recorder = try! AVAudioRecorder(url: URL(string: path)!,settings: dic!)
            
            if recorder != nil{
                recorder!.isMeteringEnabled = true
                recorder!.prepareToRecord()
                recorder!.record()
            }
        
            recordBtn.backgroundColor = UIColor.gray
        
            UserDefaults.standard.set(fileNames, forKey: "myFileNames")
            UserDefaults.standard.synchronize()
    }
    
    @IBAction func FinishPress(_ sender: Any) {
        recorder?.stop()
        recorder = nil
        
        recordBtn.backgroundColor = UIColor.white
        playBtn.isEnabled = true
    }
    
    @IBAction func playCurrentFile(_ sender: Any) {
        
        if currentRecordFileName != nil {
            var fileNames = UserDefaults.standard.array(forKey: "myFileNames") as? [String] ?? [String]()
            
            currentRecordFileName = fileNames.last
        }
        
            if player != nil && player!.isPlaying{
                player?.stop()
                playBtn.setTitle("播放", for: .normal)
            }else{
                    let path = recordFilesPath! + currentRecordFileName!
                    player = try! AVAudioPlayer(contentsOf: URL(string: path)!)
                    if player != nil{
                        player?.delegate = self
                        player?.play()
                        playBtn.setTitle("停止", for: .normal)
                    }
            }
    
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.setTitle("播放", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        if player != nil{
            player?.stop()
            player = nil
        }
    }

}

