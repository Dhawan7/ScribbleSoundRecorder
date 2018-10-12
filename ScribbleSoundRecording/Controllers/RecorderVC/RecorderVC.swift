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
    var isRecording:Bool = false
    var isSave:Bool = false
    var isPause: Bool = false
    var timer:Timer?
    var change:CGFloat = 0.01
    var popUpView: CustomPopUp!
    var dateStr = ""
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waveAudioView.density = 1.0
        dateString()
    }
    
    func dateString(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateStr = dateFormatter.string(from: date)
        print(dateStr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //viewDismissSave.alpha = 0.0
        setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 0.0, labelSave: 0.0, pauseButton: 0.0, saveButton: 0.0)
        self.redRecordButton()
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopWave()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4) {
        //   self.viewDismissSave.alpha = 0.0
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
            self.isPause = false
            self.isRecording = false
            self.isSave = false
            self.stopWave()
        }
       
    }
    
    
    @IBAction func btnStartRecord(_ sender: UIButton) {
        isPause = false
        isSave = false
        UIView.animate(withDuration: 0.3) {
          //  self.viewDismissSave.alpha = 0.0
        if self.isRecording{
//            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 0.0, labelSave: 0.0, pauseButton: 0.0, saveButton: 0.0)
//            self.finishRecording(success: true)
//            self.stopWave()
//            self.isRecording = false
//            self.waveAudioView.amplitude = 0.0
        } else{
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"),  imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
            self.redRecordButton()
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
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
               self.grayRecordButton()
               // self.viewDismissSave.alpha = 0.0
                self.stopWave()
                self.isSave = false
        } else{
           
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save-color"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                self.redRecordButton()
                self.audioRecorder.stop()
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
             //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
            //   vc.modalPresentationStyle = .currentContext
            //    vc.modalPresentationStyle = .overCurrentContext
            //    self.navigationController?.present(vc, animated: true, completion: nil)
                let vc =  UINavigationController.init(rootViewController: self.storyboard?.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp)
                vc.modalPresentationStyle = .overCurrentContext
                UIView.animate(withDuration: 0.3, animations: {
                     self.present(vc, animated: true, completion: nil)
                })
               
                  //  self.viewDismissSave.alpha = 1.0
              //  })
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
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                self.showWave()
                self.audioRecorder.record()
                self.redRecordButton()
                self.isPause = false
            } else{
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-color"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                
                self.grayRecordButton()
                self.stopWave()
                self.audioRecorder.pause()
                self.isPause = true
            }
        }
    }
    
    
    @IBAction func btnNoPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
           // self.viewDismissSave.alpha = 0.0
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageStop: #imageLiteral(resourceName: "save-color"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
            self.showWave()
            self.isPause = false
            self.isRecording = false
            self.isSave = false
        }
       
    }
    
    @IBAction func btnYesPopUP(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
      //  self.hidesBottomBarWhenPushed = true
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
