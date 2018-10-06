//  Memory Management
//  Garbedge Collection
//  RecorderVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 25/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

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
        setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 0.0, labelSave: 0.0, pauseButton: 0.0, saveButton: 0.0)
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
    
    func setButtonData(imagePause: UIImage, imageRecord: UIImage, imageStop: UIImage, labelPause: CGFloat, labelSave: CGFloat, pauseButton: CGFloat, saveButton: CGFloat){
            self.btnPause.setBackgroundImage(imagePause, for: .normal)
            self.btnRecord.setBackgroundImage(imageRecord, for: .normal)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4) {
        //   self.viewDismissSave.alpha = 0.0
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
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
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 0.0, labelSave: 0.0, pauseButton: 0.0, saveButton: 0.0)
            self.stopWave()
            self.isRecording = false
            self.waveAudioView.amplitude = 0.0
        } else{
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record-color"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
            self.timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(RecorderVC.refreshAudioView(_:)), userInfo: nil, repeats: true)
            self.isRecording = true
        }
        }
    }
    
    @IBAction func btnSaveStop(_ sender: UIButton) {
        isPause = false
        isRecording = false
         UIView.animate(withDuration: 0.2) {
            if self.isSave{
            self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
               // self.viewDismissSave.alpha = 0.0
                self.stopWave()
                self.isSave = false
        } else{
           
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save-color"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
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
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-1"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                self.stopWave()
                self.isPause = false
            } else{
                self.setButtonData(imagePause: #imageLiteral(resourceName: "pause-color"), imageRecord: #imageLiteral(resourceName: "record"), imageStop: #imageLiteral(resourceName: "save"), labelPause: 1.0, labelSave: 1.0, pauseButton: 1.0, saveButton: 1.0)
                self.stopWave()
                self.isPause = true
            }
        }
    }
    
    
    @IBAction func btnNoPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
           // self.viewDismissSave.alpha = 0.0
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
    
    @IBAction func btnDeletePopUp(_ sender: UIButton) {
        
    }
    
}
