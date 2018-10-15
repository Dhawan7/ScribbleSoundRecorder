//
//  RecorderButtonHandleVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 15/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import Foundation
import UIKit


struct RecorderButtonHandleVC {
    
    var recordBtn : UIColor!
    var pauseBtn : UIColor!
    var btnSave: UIColor!
    
    init(record: UIColor, pause: UIColor, save: UIColor) {
        self.recordBtn = record
        self.pauseBtn = pause
        self.btnSave = save
    }
    
    
}

struct LabelHandler {
    
    var lblPause : Bool!
    var lblSave : Bool!
    
    init(pause:Bool, save: Bool) {
        self.lblPause = pause
        self.lblSave = save
    }
}
