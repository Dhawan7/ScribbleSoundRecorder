//
//  AudioTest.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 11/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTest: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var audioPlayer:AVAudioPlayer!
    var audioRecorder:AVAudioRecorder!
    var recorderVC: RecorderVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
  //  @IBOutlet weak var Btn: UIButton!
    @IBAction func btn(_ sender: Any) {
        
    }
    
  
    
}
