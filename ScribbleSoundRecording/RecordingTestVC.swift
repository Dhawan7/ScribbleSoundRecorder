//
//  RecordingTestVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 19/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingTestVC: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var btnRecordPause: UIButton!
    @IBOutlet weak var recordingTableView: UITableView!
    
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayr: AVAudioPlayer!
    var numberOfRecord = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        if let number = UserDefaults.standard.object(forKey: "myNumber") as? Int{
            numberOfRecord = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("Accepted")
            }
        }
    }
    
    //func which get path to directory
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDiretory = paths[0]
        return documentDiretory
    }
    
    //func that displays alert
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnRecordPauseAct(_ sender: UIButton) {
        
        if audioRecorder == nil{
            numberOfRecord += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecord).m4a")
            let setting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do{
                audioRecorder = try AVAudioRecorder(url: fileName, settings: setting)
                audioRecorder.delegate = self
                audioRecorder.record()
                btnRecordPause.setTitle("Stop recording", for: .normal)
            } catch{
                displayAlert(title: "Error", message: "Recording Failed")
            }
        } else{
            // stoping audio recording
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.standard.set(numberOfRecord, forKey: "myNumber")
            recordingTableView.reloadData()
            btnRecordPause.setTitle("Start recording", for: .normal)
        }
    }
    
    //table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecord
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // let cell = recordingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = recordingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paths = getDirectory().appendingPathComponent("\(indexPath.row).m4a")
        do{
            audioPlayr = try AVAudioPlayer(contentsOf: paths)
            audioPlayr.play()
            print(audioPlayr.duration)
        } catch{
            
        }
        
    }
    
}



