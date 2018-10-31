//
//  RecordingListModel.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 19/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import Foundation
import UIKit

struct RecordingListModel {
    
    var recordName:String!
    var recordImage:UIImage!
    var recordDate:String!
    
    init(recordName:String, recordImage: UIImage, recordDate:String) {
        self.recordName = recordName
        self.recordImage = recordImage
        self.recordDate = recordDate
    }
}
