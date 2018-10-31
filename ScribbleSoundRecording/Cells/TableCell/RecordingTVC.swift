//
//  RecordingTVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 17/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class RecordingTVC: UITableViewCell {

    @IBOutlet weak var imageViewAlbumArt: UIImageViewX!
    @IBOutlet weak var lblTrackTitle: UILabel!
    @IBOutlet weak var lblTrackLength: UILabel!
    @IBOutlet weak var imageViewEqualizer: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    var dateStr:String = ""
    var modelRecording: RecodingData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func setRecordingData(modelObj: RecodingData){
        imageViewAlbumArt.image = UIImage(data: modelObj.image!)
        lblTrackTitle.text = modelObj.name
        
       // lblTime.text = dateString(date: modelObj.date!)
        lblTrackLength.text = "00:00"
    }

}
