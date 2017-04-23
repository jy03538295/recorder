//
//  RecordsListViewController.swift
//  recorder
//
//  Created by Dongsheng He on 2017/4/23.
//  Copyright © 2017年 Dongsheng He. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsListViewController: UIViewController,AVAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var recordsTableView: UITableView!
    
    var currentIndex:Int?
    var recordFilesPath:String?
    
    var player:AVAudioPlayer?
    
    var fileNames = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fileNames = UserDefaults.standard.array(forKey: "myFileNames") as? [String] ?? [String]()
        // Do any additional setup after loading the view.
        
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
        recordsTableView.estimatedRowHeight = 50
        recordsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordTableViewCell") as! RecordsListTableViewCell
        cell.recordNameLabel.text = fileNames[indexPath.row]
        
        if currentIndex != nil && currentIndex == indexPath.row && player != nil && player!.isPlaying  {
            cell.playButton.setTitle("停止", for: .normal)
        }else {
            cell.playButton.setTitle("播放", for: .normal)
        }
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(RecordsListViewController.playButtonTapped(playButton:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func playButtonTapped(playButton:UIButton) {
        playFileAt(index: playButton.tag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playFileAt(index:Int){
        
        if player != nil {
            player?.stop()
            player = nil
            if let cell = recordsTableView.cellForRow(at: IndexPath.init(row: currentIndex!, section: 0)) as? RecordsListTableViewCell
            {
                cell.playButton.setTitle("播放", for: .normal)
            }
            if index == currentIndex{
                return
            }
        }
        
        let path = recordFilesPath! + fileNames[index]
        player = try! AVAudioPlayer(contentsOf: URL(string: path)!)
        if player != nil{
            player?.delegate = self
            player?.play()
                let cell = recordsTableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as! RecordsListTableViewCell
            cell.playButton.setTitle("停止", for: .normal)
            currentIndex = index
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let cell = recordsTableView.cellForRow(at: IndexPath.init(row: currentIndex!, section: 0)) as! RecordsListTableViewCell
        cell.playButton.setTitle("播放", for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
