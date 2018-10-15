// file:///var/mobile/Containers/Data/Application/9984E569-37C4-4A13-AB84-45EC36EA074C/Documents/
//  RecorderVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 25/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//


import UIKit
import AVFoundation

class RecorderVC: UIViewController {
    
    //Mark: outlet's
    @IBOutlet weak var btnRecord: UIButtonX!
    @IBOutlet weak var btnPause: UIButtonX!
    @IBOutlet weak var btnStopSave: UIButtonX!
    @IBOutlet weak var viewSaveRecord: UIView!
    @IBOutlet weak var lblPause: UILabel!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewDismissSave: UIView!
    @IBOutlet weak var waveAudioView: SwiftSiriWaveformView!
    
    
    
    //Mark: let, var
    var isRecording: Bool = false
    var isSave: Bool = false
    var isPause: Bool = false
    var timer: Timer?
    var change: CGFloat = 0.01
    var popUpView: CustomPopUp!
    var dateStr = ""
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioUrl: URL!
    var buttonHandle: RecorderButtonHandleVC!
    var handleLable: LabelHandler!
    var redColor = UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
    var grayColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waveAudioView.density = 1.0
        dateString()
       // userPermission()
        
    }
    
    func dateString(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateStr = dateFormatter.string(from: date)
        print(dateStr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.redRecordButton()
        lblSave.alpha = 0.0
        lblPause.alpha = 0.0
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopWave()
        btnPause.alpha = 0.0
        btnStopSave.alpha = 0.0
        lblSave.alpha = 0.0
        lblPause.alpha = 0.0
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.waveAudioView.amplitude <= self.waveAudioView.idleAmplitude || self.waveAudioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        self.waveAudioView.amplitude += self.change
    }
    
    func stopWave(){
        
           timer?.invalidate()
            timer = nil
    }
    
    
    
    func setButtonData(imagePause: UIImage, imageStop: UIImage, labelPause: CGFloat, labelSave: CGFloat, pauseButton: CGFloat, saveButton: CGFloat){
            self.btnPause.setBackgroundImage(imagePause, for: .normal)
        
            self.btnStopSave.setBackgroundImage(imageStop, for: .normal)
            self.lblPause.alpha = labelPause
            self.lblSave.alpha = labelSave
            self.btnPause.alpha = pauseButton
            self.btnStopSave.alpha = saveButton
    }
    
    func showSideButtons(){
        btnPause.alpha = 1.0
        btnRecord.alpha = 1.0
        btnStopSave.alpha = 1.0
        
    
    }
    
   
    
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
        self.btnStopSave.backgroundColor = UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
    }
    
    func grayStopButton(){
        self.btnStopSave.backgroundColor = UIColor(displayP3Red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4) {
       
            self.isPause = false
            //self.isRecording = false
            self.isSave = false
            self.stopWave()
        }
       
    }
    
    
    @IBAction func btnStartRecord(_ sender: UIButton) {
        isPause = false
        isSave = false
        UIView.animate(withDuration: 0.3) {
         
        if self.isRecording{
            self.finishRecording(success: true)

        } else{
          
           
            
            self.lblPause.alpha = 1.0
            self.lblSave.alpha = 1.0
            self.redRecordButton()
            self.grayStopButton()
            self.grayPauseButton()
            self.startRecording()
            self.showWave()
            self.isRecording = true
        }
        }
    }
    
    func showWave(){
         self.timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(RecorderVC.refreshAudioView(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func btnSaveStop(_ sender: UIButton) {
        isPause = false
        isRecording = false
         UIView.animate(withDuration: 0.2) {
            if self.isSave{
          
               self.redRecordButton()
               self.grayPauseButton()
                self.grayStopButton()
                self.showWave()
                self.isSave = false
                self.isRecording = true
        } else{
           
                self.redSaveButton()
                self.grayRecordButton()
                self.grayPauseButton()
                self.audioRecorder.stop()
                self.isRecording = true
                
                let storyBord = self.storyboard?.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
                
                let vc =  UINavigationController.init(rootViewController: storyBord)
                
                storyBord.audioURLFromHome = self.getDocumentsDirectory()
                
                vc.modalPresentationStyle = .overCurrentContext
                UIView.animate(withDuration: 0.3, animations: {
                     self.present(vc, animated: true, completion: nil)
                })
                self.stopWave()
                self.isSave = true
            }
        }
       
        
    }
    
    @IBAction func btnPauseAct(_ sender: UIButton) {
        isRecording = false
        isSave = false
        
        UIView.animate(withDuration: 0.2) {
          //  self.viewDismissSave.alpha = 0.0
            if self.isPause{
               // self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                self.redRecordButton()
                self.grayPauseButton()
                self.grayStopButton()
                self.showWave()
                self.audioRecorder.record()
                self.isPause = false
                self.isRecording = true
            } else{
                self.redPauseButton()
                self.grayRecordButton()
                self.grayStopButton()
                self.stopWave()
                self.audioRecorder.pause()
                self.isPause = true
                self.isRecording = true
            }
        }
    }
    
    
    @IBAction func btnNoPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
           // self.viewDismissSave.alpha = 0.0
            //self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save-color"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
            self.redRecordButton()
            self.grayPauseButton()
            self.grayStopButton()
            self.showWave()
            self.isPause = false
            self.isRecording = false
            self.isSave = false
        }
       
    }
    
    @IBAction func btnYesPopUP(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
      vc.urlFromCustomPopUP = audioUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
}

extension RecorderVC: AVAudioRecorderDelegate {
    
    func userPermission(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){ [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.btnStartRecord(self.btnRecord)
                    } else {
                        print("Failed To Record")
                    }
                    
                }
            }
        } catch {
            
        }
        
    }
    
    func startRecording(){
        let audioFileName = getDocumentsDirectory().appendingPathComponent("Recording.m4a")
        let setting = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: setting)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) 
        let documentsDirectory = path[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
           
          
        } else {
    
        }
    }
    

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: true)
        }
    }

}
