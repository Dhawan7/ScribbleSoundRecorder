//
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
    @IBOutlet weak var viewPopUP: UIView!
    @IBOutlet weak var btnDelete: UIButtonX!
    @IBOutlet weak var lblRecordTimer: UILabel!
    
    
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
    var context = CoreDataStack.sharedInstance.getContext()
    var clock:Timer!
    var numberOfRecording = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waveAudioView.density = 1.0
        dateString()
        viewPopUP.alpha = 0.0
        seUpAudioRecorder()
        let entity = RecodingData.share.getData()
        print(entity)
        if let number:Int = UserDefaults.standard.object(forKey: "Recording") as? Int{
            numberOfRecording = number
        }

    }
    
    func dateString(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateStr = dateFormatter.string(from: date)
        print(dateStr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.grayRecordButton()
        isRecording = false
        lblSave.alpha = 0.0
        lblPause.alpha = 0.0
        self.viewPopUP.alpha = 0.0
        self.lblRecordTimer.text = "00:00"
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        btnPause.alpha = 0.0
        btnStopSave.alpha = 0.0
        lblSave.alpha = 0.0
        lblPause.alpha = 0.0
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func showRecording(){
//        audioDuration += 1
//        lblRecordTimer.text = String(audioDuration)
        
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.waveAudioView.amplitude <= self.waveAudioView.idleAmplitude || self.waveAudioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        self.waveAudioView.amplitude += self.change
    }
    
    func stopWave(){
            audioRecorder.pause()
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
            UIView.animate(withDuration: 0.3, animations: {
                self.viewPopUP.alpha = 0.0
            })
        }
       
    }
    
    func showWave(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(RecorderVC.refreshAudioView(_:)), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func btnStartRecord(_ sender: UIButton) {
        isPause = false
        isSave = false
        UIView.animate(withDuration: 0.3) {
         
        if self.isRecording{
            //self.finishRecording(success: true)

        } else{
            self.lblPause.alpha = 1.0
            self.lblSave.alpha = 1.0
            self.btnPause.alpha = 1.0
            self.btnStopSave.alpha = 1.0
            self.grayStopButton()
            self.grayPauseButton()
            self.redRecordButton()
            self.recordAudio()
           // self.startRecording()
            self.isRecording = true
            self.clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showRecording), userInfo: nil, repeats: true)
            self.clock.fire()
        }
        }
    }
    
   
    
    @IBAction func btnSaveStop(_ sender: UIButton) {
        isPause = false
        UIView.animate(withDuration: 0.2) {
            if self.isSave{
                self.redRecordButton()
                self.grayPauseButton()
                self.grayStopButton()
                self.showWave()
                self.isSave = false
                self.isRecording = true
                self.clock.fire()
            } else{
                self.btnDelete.isHidden = false
                self.redSaveButton()
                self.grayRecordButton()
                self.grayPauseButton()
                
                self.isSave = true
                self.audioRecorder.stop()
                self.audioRecorder = nil
                UserDefaults.setValue(self.numberOfRecording, forKey: "Recording")
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewPopUP.alpha = 1.0
                    self.clock.invalidate()
                })
            }
        }
       
        
    }
    
    @IBAction func btnPauseAct(_ sender: UIButton) {
       
        isSave = false
        
        UIView.animate(withDuration: 0.2) {
    
            if self.isPause{
                self.redRecordButton()
                self.grayPauseButton()
                self.grayStopButton()
                self.audioRecorder.record()
                self.showWave()
                self.isPause = false
                self.clock.fire()
            } else{
                self.redPauseButton()
                self.grayRecordButton()
                self.grayStopButton()
                self.audioRecorder.pause()
                self.stopWave()
                self.isPause = true
                self.clock.invalidate()
            }
        }
    }
    
    
    @IBAction func btnNoPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.viewPopUP.alpha = 0.0
            self.grayRecordButton()
            self.grayPauseButton()
            self.redSaveButton()
            self.stopWave()
            self.isSave = true
        }
       
    }
    
    @IBAction func btnYesPopUP(_ sender: UIButton) {
        self.audioRecorder.stop()
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
        vc.audioURL = getDirectory().appendingPathComponent("\(numberOfRecording + 1).m4a")
        vc.isFromBrowse = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        let popUP = UIStoryboard(name: "Main", bundle: nil)
        let vc = popUP.instantiateViewController(withIdentifier: "CustomPopUp") as! CustomPopUp
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
   
    
}

extension RecorderVC: AVAudioRecorderDelegate {
    
    
    //setting up session
    func seUpAudioRecorder(){
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("Accepted")
            }
        }
    }
    
    //function that gets path to directory
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //Display the alert
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //record function
    //check active recording
    
    func recordAudio(){
        if audioRecorder == nil{
            numberOfRecording += 1
            let filename = getDirectory().appendingPathComponent("Recording\(numberOfRecording).m4a")
            let settings = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //start recording
            do{
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                //start the waves
            } catch{
                displayAlert(title: "Error", message: "Recording failed")
            }
            
        } else{
            // stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.setValue(numberOfRecording, forKey: "Recording")
            // stop the waves
        }
    }
    
    
    
}

//extension RecorderVC: AVAudioRecorderDelegate {
//
//    func userPermission(){
//        recordingSession = AVAudioSession.sharedInstance()
//        do {
//            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission(){ [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.btnStartRecord(self.btnRecord)
//                    } else {
//                        print("Failed To Record")
//                    }
//
//                }
//            }
//        } catch {
//
//        }
//
//    }
//
//    func startRecording(){
//        let audioFileName = getDocumentsDirectory().appendingPathComponent("Recording.m4a")
//        let setting = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: setting)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//            self.showWave()
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//
//    func getDocumentsDirectory() -> URL {
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = path[0]
//        return documentsDirectory
//    }
//
//    func finishRecording(success: Bool){
//        audioRecorder.stop()
//        audioRecorder = nil
//
//        if success {
//           self.stopWave()
//
//        } else {
//
//        }
//    }
//
//
//
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: true)
//        }
//    }
//
//}

