//
//  RecordingCVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 17/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class RecordingCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageViewAlbumArt: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectViewX!
    @IBOutlet weak var lblAlbumTrackTitle: UILabel!
    @IBOutlet weak var lblTrackLength: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    func setData(modelObject:RecordingListModel){
        imageViewAlbumArt.image = modelObject.recordImage
        lblAlbumTrackTitle.text = modelObject.recordName
        lblDate.text = modelObject.recordDate
    }

}



