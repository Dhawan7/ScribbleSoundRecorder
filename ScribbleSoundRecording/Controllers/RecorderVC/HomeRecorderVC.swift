//
//  HomeRecorderVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 23/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class HomeRecorderVC: BaseVC, AVAudioRecorderDelegate{
    
    @IBOutlet weak var viewPopUP: UIView!
    @IBOutlet weak var lblPause: UILabel!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var btnSave: UIButtonX!
    @IBOutlet weak var btnPause: UIButtonX!
    @IBOutlet weak var btnRecord: UIButtonX!
    @IBOutlet weak var lblRecordDuration: UILabel!
    @IBOutlet weak var waveAudioView: SwiftSiriWaveformView!
    @IBOutlet weak var viewDeletePopUp: UIView!
    
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayr: AVAudioPlayer!
    var numberOfRecord = 0
    var isPause:Bool = false
    var isRecording:Bool = false
    var isSave:Bool = false
    var audioName:String!
    var fractions:Int = 0
    var second:Int = 0
    var min:Int = 0
    var change: CGFloat = 0.01
    var audioTimer:String = ""
    var timer = Timer()
    var waveTimer = Timer()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setUPUI()
        self.lblRecordDuration.text = "00:00"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        do{
           try recordingSession.setActive(false, with: .notifyOthersOnDeactivation)
        } catch{
            
        }
        
    }
    
    func setUPUI(){
        viewPopUP.alpha = 0.0
        viewDeletePopUp.alpha = 0.0
        grayRecordButton()
        lblSave.alpha = 0.0
        lblPause.alpha = 0.0
        btnSave.alpha = 0.0
        btnPause.alpha = 0.0
        isRecording = false
        getPermission()
        audioRecorder = nil
    }
    
    func getPermission(){
        recordingSession = AVAudioSession.sharedInstance()
//        if let number = defaults.object(forKey: "myNumber") as? Int{
//            numberOfRecord = number
//        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("Accepted")
            }
        }
    }
   
    
    func showSideButton(){
        lblPause.alpha = 1.0
        lblSave.alpha = 1.0
        btnPause.alpha = 1.0
        btnSave.alpha = 1.0
        redRecordButton()
        grayStopButton()
        grayPauseButton()
    }
    
  
    
    func runWaveTimer(){
        self.waveTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.waveAudioView.amplitude <= self.waveAudioView.idleAmplitude || self.waveAudioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        self.waveAudioView.amplitude += self.change
    }
    
    @objc func setRecordingTimer(){
        
            fractions += 1
            if fractions == 100{
                second += 1
                fractions = 0
            }
            if second == 60{
                min += 1
                second = 0
            }
       // let fractionString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondString = second > 9 ? "\(second)" : "0\(second)"
        let minString = min > 9 ? "\(min)" : "0\(min)"
        
        audioTimer = "\(minString):\(secondString)"
        lblRecordDuration.text = audioTimer
        
    }
    
    func runAuidoRecordTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(setRecordingTimer), userInfo: nil, repeats: true)
    }
    
   
    
    @IBAction func btnRecordPauseAct(_ sender: UIButton) {
        if !isRecording{
            if audioRecorder == nil{
                numberOfRecord += 1
                var audioQulity = AVAudioQuality.high.rawValue
                var audioFormat = kAudioFormatMPEG4AAC
                
                if let quality = defaults.object(forKey: "soundQuality") as? Int{
                    audioQulity = quality
                }
                if let format = defaults.object(forKey: "soundFormat") as? AudioFileTypeID{
                    audioFormat = format
                }
                
                let fileName = getDirectory().appendingPathComponent("\(numberOfRecord).m4a")
                let setting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                do{
                    audioRecorder = try AVAudioRecorder(url: fileName, settings: setting)
                    audioRecorder.delegate = self
                    self.showSideButton()
                    self.isRecording = true
                    runWaveTimer()
                    runAuidoRecordTimer()
                    if audioRecorder != nil{
                        audioRecorder.record()
                    }
                    
                } catch{
                    displayAlert(title: "Error", message: "Recording Failed")
                }
            }
        } else{
           
        }
       
    }
    
    @IBAction func btnPauseRecord(_ sender: UIButton) {
        if isPause{
            
            if audioRecorder != nil{
                grayPauseButton()
                redRecordButton()
                grayStopButton()
                runAuidoRecordTimer()
                runWaveTimer()
                isPause = false
                self.showSideButton()
                self.lblPause.text = "PAUSE"
                self.audioRecorder.record()
            }
            
            
        } else{
           // if !(audioRecorder != nil){
            
            if audioRecorder != nil{
                self.redPauseButton()
                self.grayRecordButton()
                self.grayStopButton()
                self.audioRecorder.pause()
                self.lblPause.text = "RESUME"
            }
            
                timer.invalidate()
                waveTimer.invalidate()
                isPause = true
        //    }
        }
       
    }
    
    @IBAction func btnSaveStop(_ sender: UIButton) {
        
        if audioRecorder != nil{
            redSaveButton()
            grayRecordButton()
            grayPauseButton()
            viewPopUP.alpha = 1.0
            timer.invalidate()
            waveTimer.invalidate()
            audioRecorder.pause()
        }
     
    }
    
    @IBAction func btnNo(_ sender: UIButton) {
        viewPopUP.alpha = 0.0
        
        if audioRecorder != nil{
            redRecordButton()
            grayStopButton()
            grayPauseButton()
            runAuidoRecordTimer()
            runWaveTimer()
            audioRecorder.record()
            
        }
        
        
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        timer.invalidate()
        waveTimer.invalidate()
        fractions = 0
        second = 0
        min = 0
        audioRecorder.stop()
        audioRecorder = nil
        UserDefaults.standard.set(numberOfRecord, forKey: "myNumber")
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
        vc.recordingNo = numberOfRecord
        vc.isFromBrowse = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        
        self.viewDeletePopUp.alpha = 1.0
        
//        let popUP = UIStoryboard(name: "Main", bundle: nil)
//        let vc = popUP.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteNo(_ sender: UIButton) {
        self.viewDeletePopUp.alpha = 0.0
    }
    
    @IBAction func btnDeleteYes(_ sender: UIButton) {
        deleteRecordingFile(audioName: "\(numberOfRecord).m4a")
        numberOfRecord -= 1
        timer.invalidate()
        waveTimer.invalidate()
        fractions = 0
        second = 0
        min = 0
        viewDeletePopUp.alpha = 0.0
        viewPopUP.alpha = 0.0
        lblRecordDuration.text = "00:00"
        setUPUI()
        audioRecorder = nil
    }
    
    
    
    
}




extension HomeRecorderVC{
    func redRecordButton(){
        self.btnRecord.backgroundColor =  UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
    }
    
    func grayRecordButton(){
        self.btnRecord.backgroundColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
    
    func redPauseButton(){
        self.btnPause.backgroundColor = UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
    }
    
    func grayPauseButton(){
        self.btnPause.backgroundColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
    
    func redSaveButton(){
        self.btnSave.backgroundColor = UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
    }
    
    func grayStopButton(){
        self.btnSave.backgroundColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
}
