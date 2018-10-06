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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
