//
//  SettingsVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 17/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsVC: UIViewController {
    
    @IBOutlet weak var pickerTopLine: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnSoundFormat: UIButton!
    @IBOutlet weak var btnSoundQuality: UIButton!
    @IBOutlet weak var btnRecordOnStart: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var btnMic: UIButtonX!
    
    let soundQualityList:[String:Int] = ["Low (Mono)":AVAudioQuality.low.rawValue,"Medium":AVAudioQuality.medium.rawValue,"High (Stereo)":AVAudioQuality.high.rawValue]
    let soundFormatList:[String:AudioFileTypeID] = ["Aiff":kAudioFileAIFFType,"Mp3":kAudioFileMP3Type]
    let startRecordList:[String] = ["Off (Default)","On"]
    
    var isSoundQuality:Bool! = false
    var isSoundFormat:Bool! = false
    var isOnStart:Bool! = false
    let defaults = UserDefaults.standard
    let audioRecorder: AVAudioRecorder! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView?.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        toolbar.isHidden = true
      //  pickerView.bringSubview(toFront: btnMic)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func btnSoundFormatAction(_ sender: UIButton) {
        isSoundFormat = true 
        isOnStart = false
        isSoundQuality = false
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
        toolbar.isHidden = false
        pickerTopLine.isHidden = false
    }
    @IBAction func btnSoundQualityFormat(_ sender: UIButton) {
        isSoundFormat = false
        isOnStart = false
        isSoundQuality = true
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
        toolbar.isHidden = false
        pickerTopLine.isHidden = false
    }
    @IBAction func btnRecOnStartAction(_ sender: UIButton) {
        isSoundFormat = false
        isOnStart = true
        isSoundQuality = false
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
        toolbar.isHidden = false
        pickerTopLine.isHidden = false
    }
    @IBAction func btnDoneAction(_ sender: UIBarButtonItem) {
        pickerView.isHidden = true
        toolbar.isHidden = true
        pickerTopLine.isHidden = true
   }
    
    @IBAction func btnHelp(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnAbout(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        navigationController?.pushViewController(vc, animated: true)
    
    }
    
}

extension SettingsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       if isOnStart{
            return NSAttributedString(string: startRecordList[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 14.0)! ])
        }
        if isSoundFormat{
            return NSAttributedString(string: soundFormatList[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 14.0)! ])
        }
        if isSoundQuality{
            return NSAttributedString(string: soundQualityList[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 14.0)! ])
        }
        else{
            return NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 14.0)! ])
        //}
    }*/
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isOnStart{
            return startRecordList[row]
        }
        if isSoundFormat{
            return soundFormatList.map{$0.key}[row]
        }
        if isSoundQuality{
            return soundQualityList.map{$0.key}[row]
        }
        else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isOnStart{
            btnRecordOnStart.setTitle(startRecordList[row], for: .normal)
            defaults.set(startRecordList[row], forKey: "recordOnStart")
           
        }
        if isSoundFormat{
            btnSoundFormat.setTitle(soundFormatList.map{$0.key}[row], for: .normal)
           // defaults.set(soundFormatList.map{$0.value}[row], forKey: "soundFormat")
            
            
            
        }
        if isSoundQuality{
            btnSoundQuality.setTitle(soundQualityList.map{$0.key}[row], for: .normal)
            defaults.set(soundQualityList.map{$0.value}[row], forKey: "soundQuality")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isOnStart{
            return startRecordList.count
        }
        if isSoundFormat{
            return soundFormatList.count
        }
        if isSoundQuality{
            return soundQualityList.count
        }
        else{
            return 0
        }
    }
}
